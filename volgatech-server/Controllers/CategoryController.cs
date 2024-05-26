using volgatech_server.Models.Dto;
using volgatech_server.Models.Requests.CategoryRequests;
using volgatech_server.Context;
using volgatech_server.Context.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace volgatech_server.Controllers
{
    [ApiController]
    [Route("api/category")]
    public class CategoryController : ControllerBase
    {
        private readonly IServiceScopeFactory _serviceScopeFactory;

        public CategoryController(IServiceScopeFactory serviceScopeFactory)
        {
            _serviceScopeFactory = serviceScopeFactory;
        }

        [HttpGet("list")]
        public IActionResult GetCategoryList([FromQuery] string accessToken, [FromQuery] string? searchString)
        {
            try
            {
                using IServiceScope scope = _serviceScopeFactory.CreateScope();
                LaboratoryDbContext context = scope.ServiceProvider.GetRequiredService<LaboratoryDbContext>();

                if (!context.AccessTokens.Any(x => x.Token == accessToken))
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        InvalidAccessToken = true,
                    });
                }

                var categories = new List<Category>();
                if (searchString.IsNullOrEmpty())
                {
                    categories = context.Categories.ToList();
                }
                else
                {
                    categories = context.Categories.Where(x => x.Name.Contains(searchString!)).ToList();
                }
                var categoryDtos = new List<CategoryDto>();

                if (!categories.IsNullOrEmpty())
                {
                    foreach (var category in categories)
                    {
                        var bundles = context.BundleInfos.ToList().FindAll(x => x.CategoryId == category.CategoryId).ConvertAll(x => new BundleInfoDto()
                        {
                            BundleInfoId = x.BundleInfoId,
                            CategoryId = category.CategoryId,
                            Name = x.Name,
                            Count = x.Count,
                            Images = context.Files.ToList()
                                .FindAll(e => e.TableName == "BundleInfo" && e.ObjectId == x.BundleInfoId)
                                .ConvertAll(x => x.Path),
                        });
                        categoryDtos.Add(new CategoryDto()
                        {
                            CategoryId = category.CategoryId,
                            Name = category.Name,
                            BundleInfos = bundles,
                        });
                    }
                }

                return Ok(new ResponseDto<List<CategoryDto>>()
                {
                    Success = true,
                    Data = categoryDtos,
                });
            }
            catch
            {
                return Ok(new ResponseDto<dynamic>()
                {
                    Success = false,
                });
            }
        }

        [HttpPost("create")]
        public IActionResult CreateCategory([FromQuery] string accessToken, [FromBody] CreateEditCategoryRequestDto request)
        {
            try
            {
                using IServiceScope scope = _serviceScopeFactory.CreateScope();
                LaboratoryDbContext context = scope.ServiceProvider.GetRequiredService<LaboratoryDbContext>();

                if (!context.AccessTokens.Any(x => x.Token == accessToken))
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        InvalidAccessToken = true,
                    });
                }

                var newCategory = new Category()
                {
                    Name = request.name,
                };
                context.Categories.Add(newCategory);
                context.SaveChanges();

                var categoryDto = new CategoryDto()
                {
                    CategoryId = newCategory.CategoryId,
                    Name = newCategory.Name,
                };

                categoryDto.BundleInfos = UpdateBundlesForCategory(context, newCategory, request.bundleIds ?? []);
                context.SaveChanges();

                return Ok(new ResponseDto<CategoryDto>()
                {
                    Success = true,
                    Data = categoryDto,
                });
            }
            catch
            {
                return Ok(new ResponseDto<dynamic>()
                {
                    Success = false,
                });
            }
        }

        [HttpPost("edit")]
        public IActionResult EditCategory([FromQuery] string accessToken, [FromBody] CreateEditCategoryRequestDto request)
        {
            try
            {
                using IServiceScope scope = _serviceScopeFactory.CreateScope();
                LaboratoryDbContext context = scope.ServiceProvider.GetRequiredService<LaboratoryDbContext>();

                if (!context.AccessTokens.Any(x => x.Token == accessToken))
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        InvalidAccessToken = true,
                    });
                }

                var category = context.Categories.FirstOrDefault(x => x.CategoryId == request.categoryId);
                if (category == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Категория не найдена",
                    });
                }

                category.Name = request.name;
                context.SaveChanges();

                var categoryDto = new CategoryDto()
                {
                    CategoryId = category.CategoryId,
                    Name = category.Name,
                };

                categoryDto.BundleInfos = UpdateBundlesForCategory(context, category, request.bundleIds ?? []);

                context.SaveChanges();

                return Ok(new ResponseDto<CategoryDto>()
                {
                    Success = true,
                    Data = categoryDto,
                });
            }
            catch
            {
                return Ok(new ResponseDto<dynamic>()
                {
                    Success = false,
                });
            }
        }

        [HttpPost("delete")]
        public IActionResult DeleteCategory([FromQuery] string accessToken, [FromBody] DeleteCategoryRequestDto request)
        {
            try
            {
                using IServiceScope scope = _serviceScopeFactory.CreateScope();
                LaboratoryDbContext context = scope.ServiceProvider.GetRequiredService<LaboratoryDbContext>();

                if (!context.AccessTokens.Any(x => x.Token == accessToken))
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        InvalidAccessToken = true,
                    });
                }

                var category = context.Categories.FirstOrDefault(x => x.CategoryId == request.categoryId);
                if (category == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Категория не найдена",
                    });
                }

                UpdateBundlesForCategory(context, category, []);
                context.Categories.Remove(category);
                context.SaveChanges();

                return Ok(new ResponseDto<dynamic>()
                {
                    Success = true,
                });
            }
            catch
            {
                return Ok(new ResponseDto<dynamic>()
                {
                    Success = false,
                });
            }
        }

        private List<BundleInfoDto> UpdateBundlesForCategory(LaboratoryDbContext context, Category category, List<int> newBundleIds)
        {
            if (newBundleIds.IsNullOrEmpty())
            {
                var bundleInfo = context.BundleInfos.FirstOrDefault(x => x.CategoryId == category.CategoryId);
                if (bundleInfo != null)
                {
                    bundleInfo.CategoryId = null;
                }

                return [];
            }
            else
            {
                var bundleInfoDtos = new List<BundleInfoDto>();
                var bundleInfos = context.BundleInfos.Where(x => newBundleIds.Contains(x.BundleInfoId)).ToList();

                foreach (var bundleInfo in bundleInfos)
                {
                    bundleInfo.CategoryId = category.CategoryId;
                    bundleInfoDtos.Add(new BundleInfoDto()
                    {
                        BundleInfoId = bundleInfo.BundleInfoId,
                        Name = bundleInfo.Name,
                        Count = bundleInfo.Count,
                        Images = context.Files.ToList()
                                .FindAll(e => e.TableName == "BundleInfo" && e.ObjectId == bundleInfo.BundleInfoId)
                                .ConvertAll(x => x.Path),
                    });
                }

                return bundleInfoDtos;
            }
        }
    }
}

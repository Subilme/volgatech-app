using volgatech_server.Models.Dto;
using volgatech_server.Models.Requests.BundleRequests;
using volgatech_server.Context;
using volgatech_server.Context.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace volgatech_server.Controllers
{
    [Route("api/bundle")]
    [ApiController]
    public class BundleController : ControllerBase
    {
        private readonly IServiceScopeFactory _serviceScopeFactory;

        public BundleController(IServiceScopeFactory serviceScopeFactory)
        {
            _serviceScopeFactory = serviceScopeFactory;
        }

        [HttpGet("details")]
        public IActionResult GetBundleDetails([FromQuery] string accessToken, [FromQuery] int bundleId)
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

                var bundleInfo = context.BundleInfos
                    .Include(x => x.Bundles)
                    .FirstOrDefault(x => x.BundleInfoId == bundleId);
                if (bundleInfo == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Набор не найден",
                    });
                }

                /// Сбор информации о компонентах для набора
                var bundleItemDtos = new List<BundleItemInfoDto>();
                var bundleIds = bundleInfo.Bundles.ToList().ConvertAll(x => x.BundleId).ToList();
                var bundleItemInfos = context.BundleItemInfos
                    .Include(x => x.BundleItems)
                    .Where(x => x.BundleItems.Any(e => e.BundleId != null && bundleIds.Contains((int)e.BundleId)))
                    .ToList();
                foreach (var item in bundleItemInfos)
                {
                    var count = item.BundleItems.Count() / bundleInfo.Count;
                    bundleItemDtos.Add(new BundleItemInfoDto()
                    {
                        BundleItemInfoId = item.BundleItemInfoId,
                        Name = item.Name,
                        Count = count,
                    });
                }

                /// Получение изображений набора
                var images = context.Files.ToList()
                    .FindAll(x => x.TableName == "BundleInfo" && x.ObjectId == bundleInfo.BundleInfoId)
                    .ConvertAll(x => x.Path);

                /// Получение информации о категории
                var category = context.Categories.FirstOrDefault(x => x.CategoryId == bundleInfo.CategoryId);

                var bundleDtoList = context.Bundles
                    .Include(x => x.Storage)
                    .Where(x => x.BundleInfoId == bundleInfo.BundleInfoId).ToList()
                    .ConvertAll(x => new BundleDto()
                    {
                        BundleId = x.BundleId,
                        Storage = x.Storage,
                    });

                return Ok(new ResponseDto<BundleInfoDto>
                {
                    Success = true,
                    Data = new BundleInfoDto()
                    {
                        BundleInfoId = bundleInfo.BundleInfoId,
                        Category = category == null
                            ? null
                            : new CategoryDto()
                            {
                                CategoryId = category.CategoryId,
                                Name = category.Name,
                            },
                        Name = bundleInfo.Name,
                        Count = bundleInfo.Count,
                        Description = bundleInfo.Description,
                        BundleItemInfos = bundleItemDtos,
                        Bundles = bundleDtoList,
                        Images = images,
                    },
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

        [HttpGet("list")]
        public IActionResult GetBundleInfoList([FromQuery] string accessToken, [FromQuery] string? searchString, [FromQuery] int groupByCategory)
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

                var list = context.BundleInfos.Include(x => x.Category).ToList();
                if (!searchString.IsNullOrEmpty())
                {
                    list = list.Where(x => x.Name.Contains(searchString!)).ToList();
                }

                if (groupByCategory == 1)
                {
                    list.Sort((a, b) => (a.CategoryId ?? int.MaxValue) - (b.CategoryId ?? int.MaxValue));
                }

                return Ok(new ResponseDto<List<BundleInfoDto>>()
                {
                    Success = true,
                    Data = list.ConvertAll(x => new BundleInfoDto()
                    {
                        BundleInfoId = x.BundleInfoId,
                        CategoryId = x.CategoryId,
                        Name = x.Name,
                        Count = x.Count,
                        Images = context.Files.ToList()
                            .FindAll(e => e.TableName == "BundleInfo" && e.ObjectId == x.BundleInfoId)
                            .ConvertAll(x => x.Path),
                    }),
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

        [HttpGet("instance/list")]
        public IActionResult GetBundleInstanceList([FromQuery] string accessToken, [FromQuery] int? bundleInfoId)
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

                List<Bundle> bundles = [];
                if (bundleInfoId == null)
                {
                    bundles = context.Bundles
                        .Include(x => x.BundleInfo)
                        .ToList();
                }
                else
                {
                    bundles = context.Bundles
                        .Where(x => x.BundleInfoId == bundleInfoId)
                        .Include(x => x.BundleInfo)
                        .ToList();
                }

                return Ok(new ResponseDto<List<Bundle>>
                {
                    Success = true,
                    Data = bundles,
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
        public IActionResult CreateBundle([FromQuery] string accessToken, [FromBody] CreateEditBundleRequestDto request)
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
                if (request.categoryId != null && category == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Категория для набора не найдена",
                    });
                }

                var newItem = new BundleInfo()
                {
                    Name = request.name,
                    Count = request.count,
                    Description = request.description,
                    Category = category,
                };
                context.BundleInfos.Add(newItem);
                context.SaveChanges();

                if (request.count > 0)
                {
                    for (int i = 0; i < request.count; i++)
                    {
                        var newBundle = new Bundle()
                        {
                            BundleInfoId = newItem.BundleInfoId,
                        };
                        context.Bundles.Add(newBundle);
                        context.SaveChanges();

                        UpdateBundleItemsForBundle(context, newBundle.BundleId, request.bundleItems);
                    }
                }

                return Ok(new ResponseDto<BundleInfo>
                {
                    Success = true,
                    Data = newItem,
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
        public IActionResult EditBundle([FromQuery] string accessToken, [FromBody] CreateEditBundleRequestDto request)
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

                var item = context.BundleInfos.FirstOrDefault(x => x.BundleInfoId == request.bundleId);
                if (item == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Набор не найден",
                    });
                }

                var category = context.Categories.FirstOrDefault(x => x.CategoryId == request.categoryId);
                if (request.categoryId != null && category == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Категория для набора не найдена",
                    });
                }

                item.Name = request.name;
                item.CategoryId = request.categoryId;
                item.Description = request.description;
                item.Category = category;

                if (request.count > item.Count)
                {
                    for (int i = item.Count; i < request.count; i++)
                    {
                        var newBundle = new Bundle()
                        {
                            BundleInfoId = item.BundleInfoId,
                        };
                        context.Bundles.Add(newBundle);
                        context.SaveChanges();

                        UpdateBundleItemsForBundle(context, newBundle.BundleId, request.bundleItems);
                    }
                }
                else if (request.count < item.Count)
                {
                    var bundles = context.Bundles
                        .Where(x => x.BundleInfoId == item.BundleInfoId)
                        .ToList();

                    for (int i = request.count; i < bundles.Count; i++)
                    {
                        var bundleItems = context.BundleItems.Where(x => x.BundleId == bundles[i].BundleId).ToList();
                        foreach (var bundleItem in bundleItems)
                        {
                            bundleItem.BundleId = null;
                        }

                        context.Bundles.Remove(bundles[i]);
                    }
                }

                item.Count = request.count;
                context.SaveChanges();

                return Ok(new ResponseDto<BundleInfo>
                {
                    Success = true,
                    Data = item,
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

        [HttpPost("change-storage")]
        public IActionResult ChangeBundleStorage([FromQuery] string accessToken, [FromBody] ChangeBundleStorageRequestDto request)
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

                var item = context.Bundles
                    .Include(x => x.BundleInfo)
                    .FirstOrDefault(x => x.BundleId == request.bundleId);
                if (item == null)
                {
                    return Ok(new ResponseDto<dynamic>
                    {
                        Success = false,
                        Error = "Набор не найден",
                    });
                }

                var storage = context.Storages.FirstOrDefault(x => x.StorageId == request.storageId);
                if (storage == null)
                {
                    return Ok(new ResponseDto<dynamic>
                    {
                        Success = false,
                        Error = "Склад не найден",
                    });
                }

                item.StorageId = storage.StorageId;
                context.SaveChanges();

                var bundleItems = context.BundleItems.Where(x => x.BundleId == item.BundleId);
                if (bundleItems.Any())
                {
                    foreach (var bundleItem in bundleItems)
                    {
                        bundleItem.StorageId = storage.StorageId;
                    }
                    context.SaveChanges();
                }

                return Ok(new ResponseDto<BundleDto>
                {
                    Success = true,
                    Data = new BundleDto()
                    {
                        BundleId = item.BundleId,
                        Storage = storage,
                        BundleInfo = item.BundleInfo,
                    },
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
        public IActionResult DeleteBundle([FromQuery] string accessToken, [FromBody] DeleteBundleRequestDto request)
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

                var item = context.BundleInfos.FirstOrDefault(x => x.BundleInfoId == request.bundleId);
                if (item == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Набор не найден",
                    });
                }

                if (item.Count > 0)
                {
                    var bundles = context.Bundles.Where(x => x.BundleInfoId == item.BundleInfoId).ToList();
                    foreach (var bundle in bundles)
                    {
                        var bundleItems = context.BundleItems.Where(x => x.BundleId == bundle.BundleId).ToList();
                        foreach (var bundleItem in bundleItems)
                        {
                            bundleItem.BundleId = null;
                        }

                        context.Bundles.Remove(bundle);
                    }
                }

                context.BundleInfos.Remove(item);
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

        private void UpdateBundleItemsForBundle(LaboratoryDbContext context, int bundleId, Dictionary<int, int> bundleItems)
        {
            if (!bundleItems.IsNullOrEmpty())
            {
                foreach (var item in bundleItems)
                {
                    var itemsInDbCount = context.BundleItems
                        .Where(x => x.BundleItemInfoId == item.Key && x.BundleId == bundleId)
                        .Count();

                    if (item.Value == 0)
                    {
                        continue;
                    }

                    for (int i = 0; i < (item.Value - itemsInDbCount); i++)
                    {
                        var bundleItem = context.BundleItems
                            .Where(x => x.BundleItemInfoId == item.Key).ToList()
                            .FirstOrDefault(x => x.BundleId == null);
                        if (bundleItem != null)
                        {
                            bundleItem.BundleId = bundleId;
                        }
                    }
                }
                context.SaveChanges();
            }
        }
    }
}

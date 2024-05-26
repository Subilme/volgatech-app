using volgatech_server.Models.Dto;
using volgatech_server.Context.Models;
using volgatech_server.Context;
using volgatech_server.Models.Requests.BundleItemRequests;
using volgatech_server.Models.Requests;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace volgatech_server.Controllers
{
    [Route("api/bundle-item")]
    [ApiController]
    public class BundleItemController : ControllerBase
    {
        private readonly IServiceScopeFactory _serviceScopeFactory;

        public BundleItemController(IServiceScopeFactory serviceScopeFactory)
        {
            _serviceScopeFactory = serviceScopeFactory;
        }

        [HttpGet("details")]
        public IActionResult GetBundleItemDetails([FromQuery] QueryParameters parameters, [FromQuery] int bundleItemInfoId)
        {
            try
            {
                using IServiceScope scope = _serviceScopeFactory.CreateScope();
                LaboratoryDbContext context = scope.ServiceProvider.GetRequiredService<LaboratoryDbContext>();

                if (!context.AccessTokens.Any(x => x.Token == parameters.accessToken))
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        InvalidAccessToken = true,
                    });
                }

                var bundleItemInfo = context.BundleItemInfos.FirstOrDefault(x => x.BundleItemInfoId == bundleItemInfoId);
                if (bundleItemInfo == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Набор не найден",
                    });
                }

                return Ok(new ResponseDto<BundleItemInfoDto>
                {
                    Success = true,
                    Data = new BundleItemInfoDto()
                    {
                        BundleItemInfoId = bundleItemInfo.BundleItemInfoId,
                        Name = bundleItemInfo.Name,
                        Count = context.BundleItems.Where(x => x.BundleItemInfoId == bundleItemInfoId).Count(),
                        Description = bundleItemInfo.Description,
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
        public IActionResult GetBundleItemList([FromQuery] QueryParameters parameters, [FromQuery] string? searchString)
        {
            try
            {
                using IServiceScope scope = _serviceScopeFactory.CreateScope();
                LaboratoryDbContext context = scope.ServiceProvider.GetRequiredService<LaboratoryDbContext>();

                if (!context.AccessTokens.Any(x => x.Token == parameters.accessToken))
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        InvalidAccessToken = true,
                    });
                }

                var list = new List<BundleItemInfo>();
                if (searchString.IsNullOrEmpty())
                {
                    list = context.BundleItemInfos.ToList();
                }
                else
                {
                    list = context.BundleItemInfos.Where(x => x.Name.Contains(searchString!)).ToList();
                }

                return Ok(new ResponseDto<List<BundleItemInfoDto>>()
                {
                    Success = true,
                    Data = list.ConvertAll(x => new BundleItemInfoDto()
                    {
                        BundleItemInfoId = x.BundleItemInfoId,
                        Name = x.Name,
                        Count = context.BundleItems
                            .Where(e => e.BundleItemInfoId == x.BundleItemInfoId && e.ProjectId == null)
                            .ToList().Count,
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

        [HttpGet("list/by-responsible")]
        public IActionResult GetBundleInstanceListByResponsible([FromQuery] string accessToken, [FromQuery] int responsibleId)
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

                var bundleItems = context.BundleItems
                    .Include(x => x.BundleItemInfo)
                    .Include(x => x.Project)
                    .Where(x => x.Project != null && x.Project.ResponsibleId == responsibleId)
                    .ToList();
                var list = new List<BundleItemInfoDto>();
                foreach (var bundleItem in bundleItems)
                {
                    var item = list.FirstOrDefault(x => x.BundleItemInfoId == bundleItem.BundleItemInfoId);
                    if (item == null)
                    {
                        list.Add(new BundleItemInfoDto()
                        {
                            BundleItemInfoId = bundleItem.BundleItemInfoId,
                            Name = bundleItem.BundleItemInfo.Name,
                            Count = 1,
                        });
                    }
                    else
                    {
                        item.Count++;
                    }
                }

                return Ok(new ResponseDto<List<BundleItemInfoDto>>
                {
                    Success = true,
                    Data = list,
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

        [HttpGet("list/by-storage")]
        public IActionResult GetBundleInstanceListByStorage([FromQuery] string accessToken, [FromQuery] int storageId)
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

                var bundleItems = context.BundleItems
                    .Where(x => x.StorageId == storageId)
                    .Include(x => x.BundleItemInfo)
                    .Include(x => x.Storage)
                    .ToList();
                var list = new List<BundleItemInfoDto>();
                foreach (var bundleItem in bundleItems)
                {
                    var item = list.FirstOrDefault(x => x.BundleItemInfoId == bundleItem.BundleItemInfoId);
                    if (item == null)
                    {
                        list.Add(new BundleItemInfoDto()
                        {
                            BundleItemInfoId = bundleItem.BundleItemInfoId,
                            Name = bundleItem.BundleItemInfo.Name,
                            Count = 1,
                        });
                    }
                    else
                    {
                        item.Count++;
                    }
                }

                return Ok(new ResponseDto<List<BundleItemInfoDto>>
                {
                    Success = true,
                    Data = list,
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
        public IActionResult GetBundleItemInstanceList([FromQuery] string accessToken, [FromQuery] int? bundleItemInfoId)
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

                List<BundleItem> bundleItems = [];
                if (bundleItemInfoId == null)
                {
                    bundleItems = context.BundleItems.Include(x => x.BundleItemInfo).ToList();
                }
                else
                {
                    bundleItems = context.BundleItems
                        .Where(x => x.BundleItemInfoId == bundleItemInfoId)
                        .Include(x => x.BundleItemInfo)
                        .ToList();
                }

                return Ok(new ResponseDto<List<BundleItem>>()
                {
                    Success = true,
                    Data = bundleItems,
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
        public IActionResult CreateBundleItem([FromQuery] string accessToken, [FromBody] CreateEditBundleItemRequestDto request)
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

                if (request.bundleId != null
                    && !context.Categories.Any(x => x.CategoryId == request.bundleId))
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Набор для компонента не найден",
                    });
                }

                var newItem = new BundleItemInfo()
                {
                    BundleInfoId = request.bundleId,
                    Name = request.name,
                    Count = request.count,
                };
                context.BundleItemInfos.Add(newItem);
                context.SaveChanges();

                if (request.count > 0)
                {
                    for (int i = 0; i < request.count; i++)
                    {
                        context.BundleItems.Add(new BundleItem()
                        {
                            BundleItemInfoId = newItem.BundleItemInfoId,
                            FunctionalType = 0,
                        });
                    }
                    context.SaveChanges();
                }

                return Ok(new ResponseDto<BundleItemInfo>()
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
        public IActionResult EditBundleItem([FromQuery] string accessToken, [FromBody] CreateEditBundleItemRequestDto request)
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

                var item = context.BundleItemInfos.FirstOrDefault(x => x.BundleItemInfoId == request.bundleItemId);
                if (item == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Компонент не найден",
                    });
                }

                if (request.bundleId != null
                    && !context.Categories.Any(x => x.CategoryId == request.bundleId))
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Набор для компонента не найден",
                    });
                }

                item.Name = request.name;
                item.BundleInfoId = request.bundleId;

                if (request.count > item.Count)
                {
                    for (int i = item.Count; i < request.count; i++)
                    {
                        context.BundleItems.Add(new BundleItem()
                        {
                            BundleItemInfoId = item.BundleItemInfoId,
                            FunctionalType = 0,
                        });
                    }
                }
                else if (request.count < item.Count)
                {
                    var bundleItems = context.BundleItems
                        .Where(x => x.BundleItemInfoId == item.BundleItemInfoId)
                        .ToList();
                    for (int i = request.count; i < bundleItems.Count; i++)
                    {
                        context.BundleItems.Remove(bundleItems[i]);
                    }
                }

                item.Count = request.count;
                context.SaveChanges();

                var bundleItemInfoDto = new BundleItemInfoDto()
                {
                    BundleItemInfoId = item.BundleItemInfoId,
                    Name = item.Name,
                    Count = item.Count,
                    BundleItems = context.BundleItems
                        .Include(x => x.Project)
                        .Include(x => x.Storage)
                        .Where(x => x.BundleItemInfoId == item.BundleItemInfoId)
                        .ToList()
                        .ConvertAll(x => new BundleItemDto()
                        {
                            BundleItemId = x.BundleItemId,
                            FunctionalType = x.FunctionalType,
                            Project = x.Project,
                            Storage = x.Storage,
                        }),
                };

                return Ok(new ResponseDto<BundleItemInfo>()
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

        [HttpPost("change-functional")]
        public IActionResult ChangeBundleItemFunctional([FromQuery] string accessToken, [FromBody] ChangeBundleItemFunctionalRequestDto request)
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

                var item = context.BundleItems
                    .Include(x => x.BundleItemInfo)
                    .FirstOrDefault(x => x.BundleItemId == request.bundleItemId);
                if (item == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Компонент не найден",
                    });
                }

                item.FunctionalType = request.type;
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

        [HttpPost("change-storage")]
        public IActionResult ChangeBundleItemStorage([FromQuery] string accessToken, [FromBody] ChangeBundleItemStorageRequestDto request)
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

                var item = context.BundleItems
                    .Include(x => x.BundleItemInfo)
                    .FirstOrDefault(x => x.BundleItemId == request.bundleItemId);
                if (item == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Компонент не найден",
                    });
                }

                if (request.storageId != null)
                {
                    var storage = context.Storages.FirstOrDefault(x => x.StorageId == request.storageId);
                    if (storage != null)
                    {
                        item.Storage = storage;
                    }
                }
                else if (!request.storage.IsNullOrEmpty())
                {
                    var storage = context.Storages.FirstOrDefault(x => x.Name == request.storage);
                    if (item == null)
                    {
                        storage = new Storage()
                        {
                            Name = request.storage!,
                        };
                        context.Storages.Add(storage);
                        context.SaveChanges();
                    }

                    item!.Storage = storage;
                }

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

        [HttpPost("change-project")]
        public IActionResult ChangeBundleItemProject([FromQuery] string accessToken, [FromBody] ChangeBundleItemProjectRequestDto request)
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

                var item = context.BundleItems
                    .Include(x => x.BundleItemInfo)
                    .FirstOrDefault(x => x.BundleItemId == request.bundleItemId);
                if (item == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Компонент не найден",
                    });
                }
                var project = context.Projects.FirstOrDefault(x => x.ProjectId == request.projectId);
                if (project == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Проект не найден",
                    });
                }

                item.Project = project;
                context.SaveChanges();

                return Ok(new ResponseDto<BundleItem>()
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

        [HttpPost("delete")]
        public IActionResult DeleteBundleItem([FromQuery] string accessToken, [FromBody] DeleteBundleItemRequestDto request)
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

                var item = context.BundleItemInfos.FirstOrDefault(x => x.BundleItemInfoId == request.bundleItemId);
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
                    var bundles = context.BundleItems.Where(x => x.BundleItemInfoId == item.BundleItemInfoId).ToList();
                    foreach (var bundle in bundles)
                    {
                        context.BundleItems.Remove(bundle);
                    }
                }

                context.BundleItemInfos.Remove(item);
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
    }
}

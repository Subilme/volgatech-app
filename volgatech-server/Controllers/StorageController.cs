using volgatech_server.Models.Dto;
using volgatech_server.Models.Requests.StorageRequests;
using volgatech_server.Context;
using volgatech_server.Context.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace volgatech_server.Controllers
{
    [ApiController]
    [Route("api/storage")]
    public class StorageController : ControllerBase
    {
        private readonly IServiceScopeFactory _serviceScopeFactory;

        public StorageController(IServiceScopeFactory serviceScopeFactory)
        {
            _serviceScopeFactory = serviceScopeFactory;
        }

        [HttpGet("list")]
        public IActionResult GetStorageList([FromQuery] int onlySuperStorage, [FromQuery] int? parentId, [FromQuery] string? searchString)
        {
            try
            {
                using IServiceScope scope = _serviceScopeFactory.CreateScope();
                LaboratoryDbContext context = scope.ServiceProvider.GetRequiredService<LaboratoryDbContext>();

                var list = context.Storages.ToList();

                var storages = new List<Storage>();
                foreach (var item in list)
                {
                    if (storages.Contains(item))
                    {
                        continue;
                    }

                    if (item.ParentId == null)
                    {
                        storages.Add(item);
                        storages.AddRange(list.Where(x => x.ParentId == item.StorageId));
                    }
                }

                if (parentId != null)
                {
                    storages = storages.Where(x => x.ParentId == parentId).ToList();
                }
                if (onlySuperStorage == 1)
                {
                    storages = storages.Where(x => x.ParentId == null).ToList();
                }
                if (!searchString.IsNullOrEmpty())
                {
                    storages = storages.Where(x => x.Name.Contains(searchString!)).ToList();
                }

                var dtoList = storages.ConvertAll(x => new StorageDto()
                {
                    StorageId = x.StorageId,
                    ParentStorage = list.FirstOrDefault(e => e.StorageId == x.ParentId),
                    Name = x.Name,
                    HasSubstorages = context.Storages.Any(e => e.ParentId == x.StorageId),
                });

                return Ok(new ResponseDto<List<StorageDto>>()
                {
                    Success = true,
                    Data = dtoList,
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
        public IActionResult Create([FromQuery] string accessToken, [FromBody] CreateEditStorageRequestDto request)
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

                var storage = new Storage()
                {
                    Name = request.name,
                    ParentId = request.parentId,
                };
                context.Storages.Add(storage);
                context.SaveChanges();

                return Ok(new ResponseDto<Storage>()
                {
                    Success = true,
                    Data = storage,
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
        public IActionResult Edit([FromQuery] string accessToken, [FromBody] CreateEditStorageRequestDto request)
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


                var storage = context.Storages.FirstOrDefault(x => x.StorageId == request.storageId);
                if (storage == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Склад не найден",
                    });
                }

                storage.Name = request.name;
                context.SaveChanges();

                return Ok(new ResponseDto<Storage>()
                {
                    Success = true,
                    Data = storage,
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
        public IActionResult DeleteStorage([FromQuery] string accessToken, DeleteStorageRequestDto request)
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


                var storage = context.Storages.FirstOrDefault(x => x.StorageId == request.storageId);
                if (storage == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Склад не найден",
                    });
                }

                context.Storages.Remove(storage);
                context.SaveChanges();

                return Ok(new ResponseDto<bool>()
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

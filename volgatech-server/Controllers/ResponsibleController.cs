using volgatech_server.Models.Dto;
using volgatech_server.Context.Models;
using volgatech_server.Context;
using volgatech_server.Models.Requests.ResponsibleRequests;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace volgatech_server.Controllers
{
    [ApiController]
    [Route("api/responsible")]
    public class ResponsibleController : ControllerBase
    {
        private readonly IServiceScopeFactory _serviceScopeFactory;

        public ResponsibleController(IServiceScopeFactory serviceScopeFactory)
        {
            _serviceScopeFactory = serviceScopeFactory;
        }

        [HttpGet("list")]
        public IActionResult GetResponsibleList([FromQuery] string? searchString)
        {
            try
            {
                using IServiceScope scope = _serviceScopeFactory.CreateScope();
                LaboratoryDbContext context = scope.ServiceProvider.GetRequiredService<LaboratoryDbContext>();

                var list = new List<Responsible>();
                if (searchString.IsNullOrEmpty())
                {
                    list = context.Responsibles.ToList();
                }
                else
                {
                    list = context.Responsibles.Where(x => x.Name.Contains(searchString!)).ToList();
                }

                return Ok(new ResponseDto<List<Responsible>>()
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

        [HttpPost("create")]
        public IActionResult Create([FromQuery] string accessToken, [FromBody] CreateEditResponsibleRequestDto request)
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

                var newItem = new Responsible()
                {
                    Name = request.name,
                };
                context.Responsibles.Add(newItem);
                context.SaveChanges();

                return Ok(new ResponseDto<Responsible>()
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
        public IActionResult Edit([FromQuery] string accessToken, [FromBody] CreateEditResponsibleRequestDto request)
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


                var item = context.Responsibles.FirstOrDefault(x => x.ResponsibleId == request.responsibleId);
                if (item == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Склад не найден",
                    });
                }

                item.Name = request.name;
                context.SaveChanges();

                return Ok(new ResponseDto<Responsible>()
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
        public IActionResult DeleteStorage([FromQuery] string accessToken, DeleteResponsibleRequestDto request)
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

                var item = context.Responsibles.FirstOrDefault(x => x.ResponsibleId == request.responsibleId);
                if (item == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Склад не найден",
                    });
                }

                context.Responsibles.Remove(item);
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

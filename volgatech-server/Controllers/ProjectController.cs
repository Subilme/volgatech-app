using volgatech_server.Models.Dto;
using volgatech_server.Models.Requests.ProjectRequests;
using volgatech_server.Context;
using volgatech_server.Context.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace volgatech_server.Controllers
{
    [Route("api/project")]
    [ApiController]
    public class ProjectController : ControllerBase
    {
        private readonly IServiceScopeFactory _serviceScopeFactory;

        public ProjectController(IServiceScopeFactory serviceScopeFactory)
        {
            _serviceScopeFactory = serviceScopeFactory;
        }

        [HttpGet("list")]
        public IActionResult GetProjectList([FromQuery] string accessToken)
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
                        Error = "Отказано в доступе",
                    });
                }

                return Ok(new ResponseDto<List<Project>>()
                {
                    Success = true,
                    Data = context.Projects.Include(x => x.Responsible).ToList(),
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

        [HttpGet("details")]
        public IActionResult GetProjectDetails([FromQuery] string accessToken, [FromQuery] int projectId)
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
                        Error = "Отказано в доступе",
                    });
                }

                var item = context.Projects.Include(x => x.Responsible).FirstOrDefault(x => x.ProjectId == projectId);
                if (item == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Проект не найден",
                    });
                }

                var bundleItems = context.BundleItems
                    .Include(x => x.BundleItemInfo)
                    .Include(x => x.Storage)
                    .Where(x => x.ProjectId == item.ProjectId)
                    .ToList();
                var bundleItemDtos = new List<BundleItemInfoDto>();
                foreach (var bundleItem in bundleItems)
                {
                    if (bundleItemDtos.Any(x => x.BundleItemInfoId == bundleItem.BundleItemInfoId))
                    {
                        continue;
                    }

                    bundleItemDtos.Add(new BundleItemInfoDto()
                    {
                        BundleItemInfoId = bundleItem.BundleItemInfoId,
                        Name = bundleItem.BundleItemInfo.Name,
                        Count = bundleItems
                            .Where(e => e.BundleItemInfoId == bundleItem.BundleItemInfoId)
                            .Count(),
                    });
                }

                return Ok(new ResponseDto<ProjectDto>()
                {
                    Success = true,
                    Data = new ProjectDto()
                    {
                        ProjectId = item.ProjectId,
                        Name = item.Name,
                        Description = item.Description,
                        Responsible = item.Responsible,
                        BundleItems = bundleItemDtos,
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

        [HttpPost("create")]
        public IActionResult CreateProject([FromQuery] string accessToken, [FromBody] CreateEditProjectRequestDto request)
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
                        Error = "Отказано в доступе",
                    });
                }

                if (request.bundleItems.IsNullOrEmpty())
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Необходимо добавить компоненты",
                    });
                }

                var newProject = new Project()
                {
                    Name = request.name,
                    Description = request.description,
                    Responsible = FindResponsible(context, request.responsibleId, request.responsible),
                };
                context.Projects.Add(newProject);
                context.SaveChanges();

                UpdateBundleItemsForProject(context, newProject.ProjectId, request.bundleItems);

                return Ok(new ResponseDto<ProjectDto>()
                {
                    Success = true,
                    Data = new ProjectDto()
                    {
                        ProjectId = newProject.ProjectId,
                        Name = newProject.Name,
                        Responsible = newProject.Responsible,
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

        [HttpPost("edit")]
        public IActionResult EditProject([FromQuery] string accessToken, [FromBody] CreateEditProjectRequestDto request)
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
                        Error = "Отказано в доступе",
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

                project.Name = request.name;
                project.Description = request.description;
                project.Responsible = FindResponsible(context, request.responsibleId, request.responsible);

                UpdateBundleItemsForProject(context, project.ProjectId, request.bundleItems);

                return Ok(new ResponseDto<Project>()
                {
                    Success = true,
                    Data = project,
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
        public IActionResult DeleteProject([FromQuery] string accessToken, [FromBody] DeleteProjectRequestDto request)
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
                        Error = "Отказано в доступе",
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

                context.BundleItems.Where(x => x.ProjectId == request.projectId).ToList().ForEach(x =>
                {
                    x.ProjectId = null;
                });
                context.Projects.Remove(project);
                context.SaveChanges();

                return Ok(new ResponseDto<Project>()
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

        private Responsible? FindResponsible(LaboratoryDbContext context, int? responsibleId, string? responsible)
        {
            if (responsibleId != null)
            {
                var item = context.Responsibles.FirstOrDefault(x => x.ResponsibleId == responsibleId);
                if (item != null)
                {
                    return item;
                }
            }
            else if (!responsible.IsNullOrEmpty())
            {
                var item = context.Responsibles.FirstOrDefault(x => x.Name == responsible);
                if (item == null)
                {
                    item = new Responsible()
                    {
                        Name = responsible!,
                    };
                    context.Responsibles.Add(item);
                    context.SaveChanges();
                }

                return item;
            }

            return null;
        }

        private void UpdateBundleItemsForProject(LaboratoryDbContext context, int projectId, Dictionary<int, int> bundleItems)
        {
            if (!bundleItems.IsNullOrEmpty())
            {
                foreach (var bundle in bundleItems)
                {
                    var itemsInDbCount = context.BundleItems
                        .Where(x => x.BundleItemInfoId == bundle.Key && x.ProjectId == projectId)
                        .Count();

                    if (bundle.Value == 0)
                    {
                        continue;
                    }

                    for (int i = 0; i < (bundle.Value - itemsInDbCount); i++)
                    {
                        var bundleItem = context.BundleItems
                            .Where(x => x.BundleItemInfoId == bundle.Key).ToList()
                            .FirstOrDefault(x => x.ProjectId == null);
                        if (bundleItem != null)
                        {
                            bundleItem.ProjectId = projectId;
                        }
                    }
                }
                context.SaveChanges();
            }
        }
    }
}

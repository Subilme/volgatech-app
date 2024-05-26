using volgatech_server.Context.Models;

namespace volgatech_server.Models.Dto
{
    public class ProjectDto
    {
        public int ProjectId { get; set; }

        public string? Name { get; set; }

        public string? Description { get; set; }

        public Responsible? Responsible { get; set; }

        public ICollection<BundleItemInfoDto> BundleItems { get; set; } = new HashSet<BundleItemInfoDto>();
    }
}

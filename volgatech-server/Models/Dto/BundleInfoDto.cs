namespace volgatech_server.Models.Dto
{
    public class BundleInfoDto
    {
        public int BundleInfoId { get; set; }

        public int? CategoryId { get; set; }

        public string? Name { get; set; }

        public int Count { get; set; }

        public string? Description { get; set; }

        public CategoryDto? Category { get; set; }

        public ICollection<BundleDto> Bundles { get; set; } = new HashSet<BundleDto>();
        
        public ICollection<BundleItemInfoDto> BundleItemInfos { get; set; } = new HashSet<BundleItemInfoDto>();

        public ICollection<string> Images { get; set; } = new HashSet<string>();
    }
}

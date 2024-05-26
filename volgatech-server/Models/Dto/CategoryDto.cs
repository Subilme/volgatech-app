namespace volgatech_server.Models.Dto
{
    public class CategoryDto
    {
        public int CategoryId { get; set; }

        public string? Name { get; set; }

        public ICollection<BundleInfoDto> BundleInfos { get; set; } = new HashSet<BundleInfoDto>();
    }
}

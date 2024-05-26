namespace volgatech_server.Models.Dto
{
    public class BundleItemInfoDto
    {
        public int BundleItemInfoId { get; set; }

        public string? Name { get; set; }

        public int Count { get; set; }

        public string? Description { get; set; }

        public ICollection<BundleItemDto> BundleItems { get; set; } = new HashSet<BundleItemDto>();
    }
}

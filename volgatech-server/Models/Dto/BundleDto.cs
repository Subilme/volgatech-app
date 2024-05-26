using volgatech_server.Context.Models;

namespace volgatech_server.Models.Dto
{
    public class BundleDto
    {
        public int BundleId { get; set; }

        public Storage? Storage { get; set; }

        public BundleInfo BundleInfo { get; set; }

        public ICollection<BundleItemDto> BundleItems { get; set; } = new HashSet<BundleItemDto>();
    }
}

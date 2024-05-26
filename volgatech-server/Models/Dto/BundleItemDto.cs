using volgatech_server.Context.Models;

namespace volgatech_server.Models.Dto
{
    public class BundleItemDto
    {
        public int BundleItemId { get; set; }

        public int FunctionalType { get; set; }

        public BundleItemInfo BundleItemInfo { get; set; }

        public Project? Project { get; set; }
        
        public Storage? Storage { get; set; }

        public Bundle? Bundle { get; set; }
    }
}

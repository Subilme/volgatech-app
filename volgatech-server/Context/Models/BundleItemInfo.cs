using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace volgatech_server.Context.Models
{
    public class BundleItemInfo
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int BundleItemInfoId { get; set; }

        [ForeignKey(nameof(BundleInfo))]
        public int? BundleInfoId;

        [Column]
        [StringLength(255)]
        public string? Name { get; set; }

        [Column]
        public string? Description { get; set; }

        [Column]
        public int Count { get; set; }

        [InverseProperty(nameof(BundleItem.BundleItemInfo))]
        public ICollection<BundleItem> BundleItems { get; set; } = new HashSet<BundleItem>();

        public BundleInfo? BundleInfo { get; set; }
    }
}

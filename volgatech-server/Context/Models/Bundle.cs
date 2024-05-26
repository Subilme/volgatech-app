using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace volgatech_server.Context.Models
{
    [Table("Bundles")]
    public class Bundle
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int BundleId { get; set; }

        [ForeignKey(nameof(BundleInfo))]
        public int BundleInfoId { get; set; }

        [ForeignKey(nameof(Storage))]
        public int? StorageId { get; set; }

        [InverseProperty(nameof(BundleItem.Bundle))]
        public ICollection<BundleItem> BundleItems { get; set; } = new HashSet<BundleItem>();

        public BundleInfo BundleInfo { get; set; }

        public Storage? Storage { get; set; }
    }
}

using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace volgatech_server.Context.Models
{
    [Table("BundleItems")]
    public class BundleItem
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int BundleItemId { get; set; }

        [ForeignKey(nameof(Bundle))]
        public int? BundleId { get; set; }

        [ForeignKey(nameof(BundleItemInfo))]
        public int BundleItemInfoId { get; set; }

        [ForeignKey(nameof(Project))]
        public int? ProjectId { get; set; }

        [ForeignKey(nameof(Storage))]
        public int? StorageId { get; set; }

        [Column]
        public int FunctionalType { get; set; }

        public Bundle? Bundle { get; set; }

        public BundleItemInfo BundleItemInfo { get; set; }

        public Project? Project { get; set; }

        public Storage? Storage { get; set; }
    }
}

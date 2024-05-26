using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace volgatech_server.Context.Models
{
    [Table("BundleInfos")]
    public class BundleInfo
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int BundleInfoId { get; set; }

        [ForeignKey(nameof(Category))]
        public int? CategoryId { get; set; }

        [Column]
        [StringLength(255)]
        public string? Name { get; set; }

        [Column]
        public int Count { get; set; }

        [Column]
        public string? Description { get; set; }

        [InverseProperty(nameof(Bundle.BundleInfo))]
        public ICollection<Bundle> Bundles { get; set; } = new HashSet<Bundle>();

        public Category? Category { get; set; }
    }
}

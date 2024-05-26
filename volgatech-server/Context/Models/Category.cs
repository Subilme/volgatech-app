using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace volgatech_server.Context.Models
{
    [Table("Categories")]
    public class Category
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int CategoryId { get; set; }

        [Column]
        [StringLength(255)]
        public string? Name { get; set; }

        [InverseProperty(nameof(BundleInfo.Category))]
        public ICollection<BundleInfo> BundleInfos { get; set; } = new HashSet<BundleInfo>();
    }
}

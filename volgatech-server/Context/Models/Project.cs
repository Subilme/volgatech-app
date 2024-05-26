using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace volgatech_server.Context.Models
{
    [Table("Projects")]
    public class Project
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ProjectId { get; set; }

        [Column]
        [StringLength(255)]
        public int? ResponsibleId { get; set; }

        [Column]
        [StringLength(255)]
        public string? Name { get; set; }

        [Column]
        [StringLength(255)]
        public string? Description { get; set; }

        [InverseProperty(nameof(BundleItem.Project))]
        public ICollection<BundleItem> BundleItems { get; set; } = new HashSet<BundleItem>();

        public Responsible? Responsible { get; set; }
    }
}

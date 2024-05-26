using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace volgatech_server.Context.Models
{
    [Table("Storages")]
    public class Storage
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int StorageId { get; set; }

        [Column]
        public int? ParentId { get; set; }

        [Column]
        [StringLength(255)]
        public string Name { get; set; }
    }
}

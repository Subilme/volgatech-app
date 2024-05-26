using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace volgatech_server.Context.Models
{
    [Table("Responsibles")]
    public class Responsible
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ResponsibleId { get; set; }

        [Column]
        [StringLength(255)]
        public string Name { get; set; }
    }
}

using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace volgatech_server.Context.Models
{
    [Table("Users")]
    public class User
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int UserId { get; set; }

        [Column]
        [StringLength(255)]
        public string? Name { get; set; }

        [Column]
        [StringLength(255)]
        public string? Login { get; set; }

        [Column]
        public int UserRole { get; set; }

        [StringLength(100)]
        public string PasswordSalt { get; set; }

        [StringLength(100)]
        public string PasswordHash { get; set; }
    }
}

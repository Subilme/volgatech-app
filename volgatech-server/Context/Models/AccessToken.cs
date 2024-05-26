using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace volgatech_server.Context.Models
{
    [Table("AccessTokens")]
    public class AccessToken
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int AccessTokenId { get; set; }

        [ForeignKey(nameof(User))]
        public int UserId { get; set; }

        [Column]
        public string Token { get; set; }

        public User User { get; set; }
    }
}

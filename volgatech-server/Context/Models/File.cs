using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace volgatech_server.Context.Models
{
    [Table("Files")]
    public class File
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int FileId { get; set; }

        [Column]
        public string Path { get; set; }

        [Column]
        public string TableName { get; set; }

        [Column]
        public int ObjectId { get; set; }
    }
}

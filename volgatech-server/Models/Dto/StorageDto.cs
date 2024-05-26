using volgatech_server.Context.Models;

namespace volgatech_server.Models.Dto
{
    public class StorageDto
    {
        public int StorageId { get; set; }
        
        public Storage? ParentStorage { get; set; }

        public bool HasSubstorages { get; set; }

        public string Name { get; set; }
    }
}

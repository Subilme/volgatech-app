namespace volgatech_server.Models.Requests.StorageRequests
{
    public class CreateEditStorageRequestDto
    {
        public int? storageId { get; set; }
        public int? parentId { get; set; }
        public string name { get; set; }
    }
}

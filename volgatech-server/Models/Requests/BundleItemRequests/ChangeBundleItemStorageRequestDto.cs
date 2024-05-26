namespace volgatech_server.Models.Requests.BundleItemRequests
{
    public class ChangeBundleItemStorageRequestDto
    {
        public int bundleItemId { get; set; }
        public int? storageId { get; set; }
        public string? storage { get; set; }
    }
}

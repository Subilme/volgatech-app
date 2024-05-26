namespace volgatech_server.Models.Requests.BundleRequests
{
    public class CreateEditBundleRequestDto
    {
        public int? bundleId {  get; set; }
        public int? categoryId { get; set; }

        public string name { get; set; }

        public int count { get; set; }

        public int? storageId { get; set; }

        public string? description { get; set; }

        public Dictionary<int, int> bundleItems { get; set; }
    }
}

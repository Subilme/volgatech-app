namespace volgatech_server.Models.Requests.BundleItemRequests
{
    public class CreateEditBundleItemRequestDto
    {
        public int? bundleItemId {  get; set; }

        public int? bundleId { get; set; }

        public string name { get; set; }

        public int count { get; set; }
    }
}

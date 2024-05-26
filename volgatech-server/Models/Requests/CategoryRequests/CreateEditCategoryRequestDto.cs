namespace volgatech_server.Models.Requests.CategoryRequests
{
    public class CreateEditCategoryRequestDto
    {
        public int? categoryId { get; set; }
        public string name { get; set; }
        public List<int>? bundleIds { get; set; }
    }
}

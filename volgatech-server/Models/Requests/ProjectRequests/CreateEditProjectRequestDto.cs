namespace volgatech_server.Models.Requests.ProjectRequests
{
    public class CreateEditProjectRequestDto
    {
        public int? projectId { get; set; }
        public string name { get; set; }
        public string? description { get; set; }
        public int? responsibleId { get; set; }
        public string? responsible { get; set; }
        public Dictionary<int, int> bundleItems { get; set; }
    }
}

namespace volgatech_server.Models.Requests
{
    public class QueryParameters
    {
        public string accessToken { get; set; }

        public int? offset { get; set; }

        public int? limit { get; set; } = 50;
    }
}

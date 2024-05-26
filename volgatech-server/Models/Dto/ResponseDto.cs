namespace volgatech_server.Models.Dto
{
    public class ResponseDto<T>
    {
        public bool Success { get; set; }
        public bool InvalidAccessToken { get; set; }
        public string? Error { get; set; }
        public T? Data { get; set; }
    }
}

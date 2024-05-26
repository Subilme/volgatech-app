namespace volgatech_server.Models.Requests.UserRequests
{
    public class RegisterRequestDto
    {
        public string name { get; set; }
        public string login { get; set; }
        public string password { get; set; }
        public int userRole { get; set; }
    }
}

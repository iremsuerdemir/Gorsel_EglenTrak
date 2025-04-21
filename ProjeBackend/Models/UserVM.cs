namespace ProjeBackend.Models
{
    public class UserVM
    {
        public int Id { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }

        public UserVM(int id, string userName, string email)
        {
            Id = id;
            UserName = userName;
            Email = email;
        }
    }
}

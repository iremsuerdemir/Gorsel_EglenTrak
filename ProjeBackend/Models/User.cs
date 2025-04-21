using System.ComponentModel.DataAnnotations;

namespace ProjeBackend.Models

{
    public class User
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public required string UserName { get; set; }
        [Required]
        public required string Email { get; set; }
        [Required]
        public string Password { get; set; }

    }
}

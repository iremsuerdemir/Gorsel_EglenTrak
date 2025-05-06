using System.Collections;
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
        public required string Password { get; set; }
        public ICollection<Game>? Games { get; set; }
        public ICollection<Score>? Scores { get; set; }
        public ICollection<Question>? Questions { get; set; }

    }
}

using System.ComponentModel.DataAnnotations;

namespace ProjeBackend.Models
{
    public class Game
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public required string Name { get; set; }

        [Required]
        public required string Description { get; set; }

        [Required]
        public required int Round { get; set; }

        [Required]
        public required string ImagePath { get; set; }

        [Required]
        public int PlayCount { get; set; } = 0;

        // Bir oyun birden fazla karta sahip olabilir
        public ICollection<Card>? Cards { get; set; } // Game'den Card'a doğru ilişki

        public int UserId { get; set; }  // Foreign Key
        public User? User { get; set; }   // Navigation Property
    }
}

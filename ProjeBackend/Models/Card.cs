using System.ComponentModel.DataAnnotations;

namespace ProjeBackend.Models
{
    public class Card
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public required string Name { get; set; }

        [Required]
        public required string ImagePath { get; set; }

        // Her kartın bir Game'e ait olduğunu belirtmek için Foreign Key
        public int GameId { get; set; }  // Game modeline ait referans
        public Game? Game { get; set; }  // İlişkili Game nesnesi
    }
}

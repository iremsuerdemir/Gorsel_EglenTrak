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
    }
}

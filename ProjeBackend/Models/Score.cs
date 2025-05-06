// Dosya yolu: ProjeBackend/Models/Score.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProjeBackend.Models
{
    public class Score
    {
        [Key]
        public int ScoreId { get; set; }
        [Required]
        public String userName {get;set;}

        [Required]
        [ForeignKey("Question")] // Question modeli ile ilişkiyi belirtir (Category alanına göre DEĞİL, birincil anahtara göre)
        public int QuestionId { get; set; } // Question tablosunun birincil anahtarını tutmalı
        public Question? Question { get; set; } // Navigation property (nullable olabilir)

        [Required]
        [ForeignKey("User")] // User modeli ile ilişkiyi belirtir (Id alanına göre)
        public int UserId { get; set; }
        public User? User { get; set; } // Navigation property (nullable olabilir)

        [Required]
        public string? Category { get; set; } // Question tablosundaki Category bilgisini tutar (ilişki için doğrudan foreign key olmayabilir)

        [Required]
        public int ScorePuan { get; set; }

        [Required]
        public DateTime Datetime { get; set; } = DateTime.Now;
    }
}
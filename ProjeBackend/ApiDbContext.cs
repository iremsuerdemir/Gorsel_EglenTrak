using Microsoft.EntityFrameworkCore;
using ProjeBackend.Models;

namespace ProjeBackend
{
    public class ApiDbContext : DbContext
    {
        public ApiDbContext(DbContextOptions<ApiDbContext> options) : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<Game> Games { get; set; }
        public DbSet<Card> Card { get; set; }
        public DbSet<Question> Questions { get; set; }
        public DbSet<Score> Scores { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Game ve Card arasındaki ilişkiler
            modelBuilder.Entity<Card>()
                .HasOne(c => c.Game)     // Her Card bir Game'e ait olacak
                .WithMany(g => g.Cards)   // Bir Game birden fazla Card'a sahip olabilir
                .HasForeignKey(c => c.GameId);   // GameId, Card'da foreign key olacak

            modelBuilder.Entity<Game>()
                .HasOne(g => g.User)         // Her oyun bir kullanıcıya ait
                .WithMany(u => u.Games)       // Bir kullanıcı birden fazla oyuna sahip olabilir
                .HasForeignKey(g => g.UserId); // Foreign key olarak UserId kullanılacak

            // User ve Score arasındaki ilişki
            modelBuilder.Entity<Score>()
                .HasOne(s => s.User)         // Her skor bir kullanıcıya ait olacak
                .WithMany(u => u.Scores)       // Bir kullanıcı birden fazla skora sahip olabilir
                .HasForeignKey(s => s.UserId); // UserId, Score'da foreign key olacak

            // Question ve Score arasındaki ilişki (Category üzerinden DEĞİL, QuestionId üzerinden)
            modelBuilder.Entity<Score>()
                .HasOne(s => s.Question)     // Her skor bir soruya ait olacak
                .WithMany(q => q.Scores)       // Bir soru birden fazla skora sahip olabilir
                .HasForeignKey(s => s.QuestionId); // QuestionId, Score'da foreign key olacak

            // Eğer Category üzerinden de dolaylı bir ilişki kurmak isterseniz (veri bütünlüğü için önerilir):
            // modelBuilder.Entity<Score>()
            //     .HasOne(s => s.Question)
            //     .WithMany() // Question tarafında doğrudan bir navigation property'sine gerek yoksa
            //     .HasForeignKey(s => s.QuestionId)
            //     .OnDelete(DeleteBehavior.Restrict); // Silinmeyi kısıtlayabilir veya başka bir davranış belirleyebilirsiniz.

            // NOT: Category üzerinden doğrudan foreign key ilişkisi kurmak, Category alanının Questions tablosunda benzersiz olmaması durumunda uygun değildir. Bu nedenle QuestionId üzerinden ilişki kurulması daha doğrudur. Eğer Score tablosunda Question'ın Category bilgisini tutmak istiyorsanız, bunu normal bir property olarak tutabilirsiniz (zaten modelinizde mevcut).
        }
    }
}
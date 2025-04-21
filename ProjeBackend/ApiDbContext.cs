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

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Game ve Card arasındaki ilişkiler
            modelBuilder.Entity<Card>()
                .HasOne(c => c.Game)  // Her Card bir Game'e ait olacak
                .WithMany(g => g.Cards)  // Bir Game birden fazla Card'a sahip olabilir
                .HasForeignKey(c => c.GameId);  // GameId, Card'da foreign key olacak

            modelBuilder.Entity<Game>()
                .HasOne(g => g.User)           // Her oyun bir kullanıcıya ait
                .WithMany(u => u.Games)        // Bir kullanıcı birden fazla oyuna sahip olabilir
                .HasForeignKey(g => g.UserId); // Foreign key olarak UserId kullanılacak 
        }
    }
}

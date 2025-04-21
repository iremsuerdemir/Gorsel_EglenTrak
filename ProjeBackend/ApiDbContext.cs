using Microsoft.EntityFrameworkCore;
using ProjeBackend.Models;

namespace ProjeBackend
{
    public class ApiDbContext : DbContext
    {
        public ApiDbContext(DbContextOptions<ApiDbContext> options) : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<ProjeBackend.Models.Card> Card { get; set; } = default!;
    }
}

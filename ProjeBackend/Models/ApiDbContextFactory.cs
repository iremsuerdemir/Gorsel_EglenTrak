using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;


namespace ProjeBackend
{
    public class ApiDbContextFactory : IDesignTimeDbContextFactory<ApiDbContext>
    {
        public ApiDbContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<ApiDbContext>();
            optionsBuilder.UseSqlServer("Server=localhost;Database=GorselProje;Trusted_Connection=True;MultipleActiveResultSets=True;TrustServerCertificate=True;");

            return new ApiDbContext(optionsBuilder.Options);
        }
    }
}

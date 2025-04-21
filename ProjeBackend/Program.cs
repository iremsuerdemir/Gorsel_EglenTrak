using Microsoft.EntityFrameworkCore;
using ProjeBackend;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();

// Swagger / OpenAPI yapýlandýrmasý
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Veritabaný baðlantýsý
builder.Services.AddDbContext<ApiDbContext>(option =>
    option.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// CORS yapýlandýrmasý — herkese izin veren yapý
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy => policy
            .AllowAnyOrigin()    // Tüm domainlere izin
            .AllowAnyMethod()    // GET, POST, PUT, DELETE vs.
            .AllowAnyHeader());  // Tüm headerlara izin
});

var app = builder.Build();

// Swagger sadece Development ortamýnda aktif
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// CORS middleware — Authorization'dan önce çaðýr
app.UseCors("AllowAll");

app.UseAuthorization();

app.MapControllers();

app.Run();

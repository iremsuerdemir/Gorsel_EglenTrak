using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.FileProviders;
using ProjeBackend;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
        options.JsonSerializerOptions.WriteIndented = true;
    });


// Swagger / OpenAPI yap�land�rmas�
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Veritaban� ba�lant�s�
builder.Services.AddDbContext<ApiDbContext>(option =>
    option.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// CORS yap�land�rmas� � herkese izin veren yap�
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy => policy
            .AllowAnyOrigin()    // T�m domainlere izin
            .AllowAnyMethod()    // GET, POST, PUT, DELETE vs.
            .AllowAnyHeader());  // T�m headerlara izin
});

var app = builder.Build();




app.UseRouting();

// Swagger sadece Development ortam�nda aktif
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// CORS middleware � Authorization'dan �nce �a��r
app.UseCors("AllowAll");

app.UseStaticFiles(new StaticFileOptions
{
    OnPrepareResponse = ctx =>
    {
        ctx.Context.Response.Headers.Append("Access-Control-Allow-Origin", "*");
    }
});

app.UseAuthorization();

app.MapControllers();

app.Run();

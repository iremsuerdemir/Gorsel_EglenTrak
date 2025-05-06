using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

using ProjeBackend.Models;        

namespace ProjeBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class QuestionsController : ControllerBase
    {
        private readonly ApiDbContext _context;

        public QuestionsController(ApiDbContext context)
        {
            _context = context;
        }

        // GET: https://localhost:7176/api/questions
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Question>>> GetAll()
        {
            return await _context.Questions.ToListAsync();
        }

        // GET: https://localhost:7176/api/questions/categories
        [HttpGet("categories")]
        public async Task<ActionResult<IEnumerable<string>>> GetCategories()
        {
            return await _context.Questions
                                    .Select(q => q.Category)
                                    .Distinct()
                                    .ToListAsync();
        }

        // GET: https://localhost:7176/api/questions/by-category/{category}
        [HttpGet("by-category/{category}")]
public async Task<ActionResult<IEnumerable<Question>>> GetByCategory(string category)
{
    
    var list = await _context.Questions
        .Where(q => q.Category.ToLower() == category.ToLower())
        .ToListAsync();

    // Eğer kategoriye ait soru bulunmazsa, mevcut kategorilerle birlikte hata mesajı dön
    if (!list.Any())
    {
        var availableCategories = await _context.Questions
            .Select(q => q.Category)
            .Distinct()
            .Where(c => c != null)   
            .ToListAsync();

        return NotFound($"\"{category}\" kategorisinde soru bulunamadı. Mevcut kategoriler: {string.Join(", ", availableCategories)}");
    }

    
    return list;
}
        // POST: https://localhost:7176/api/questions
        [HttpPost]
        public async Task<ActionResult<Question>> Create(Question question)
        {
            _context.Questions.Add(question);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetAll), new { id = question.Id }, question);
        }
    }
}
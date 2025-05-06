using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjeBackend.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ProjeBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ScoresController : ControllerBase
    {
        private readonly ApiDbContext _context;

        public ScoresController(ApiDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<object>>> GetAll()
        {
            return await _context.Scores
                .Include(s => s.User)
                .Select(s => new
                {
                    s.ScoreId,
                    s.QuestionId,
                    s.UserId,
                    s.Category,
                    s.ScorePuan,
                    s.Datetime,
                    UserName = s.User != null ? s.User.UserName : "Bilinmeyen Kullanıcı" // Kullanıcı adı null ise "Bilinmeyen Kullanıcı" göster
                })
                .ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<object>> GetById(int id)
        {
            var score = await _context.Scores
                .Include(s => s.User)
                .Where(s => s.ScoreId == id)
                .Select(s => new
                {
                    s.ScoreId,
                    s.QuestionId,
                    s.UserId,
                    s.Category,
                    s.ScorePuan,
                    s.Datetime,
                    UserName = s.User != null ? s.User.UserName : "Bilinmeyen Kullanıcı"
                })
                .FirstOrDefaultAsync();

            if (score == null)
            {
                return NotFound();
            }

            return score;
        }

        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<object>>> GetByUserId(int userId)
        {
            var scores = await _context.Scores
                .Where(s => s.UserId == userId)
                .Include(s => s.User)
                .Select(s => new
                {
                    s.ScoreId,
                    s.QuestionId,
                    s.UserId,
                    s.Category,
                    s.ScorePuan,
                    s.Datetime,
                     UserName = s.User != null ? s.User.UserName : "Bilinmeyen Kullanıcı"
                })
                .ToListAsync();

            if (!scores.Any())
            {
                return NotFound($"\"{userId}\" ID'li kullanıcıya ait skor bulunamadı.");
            }

            return scores.ToList();
        }

        [HttpGet("category/{category}")]
        public async Task<ActionResult<IEnumerable<object>>> GetByCategory(string category)
        {
            var scores = await _context.Scores
                .Include(s => s.User)
                .Include(s => s.Question)
                .Where(s => s.Question != null && s.Question.Category.ToLower() == category.ToLower())
                .Select(s => new
                {
                    s.ScoreId,
                    s.QuestionId,
                    s.UserId,
                    s.Category,
                    s.ScorePuan,
                    s.Datetime,
                    UserName = s.User != null ? s.User.UserName : "Bilinmeyen Kullanıcı"
                })
                .ToListAsync();

            if (!scores.Any())
            {
                var availableCategories = await _context.Questions
                    .Select(q => q.Category)
                    .Distinct()
                    .Where(c => c != null)
                    .ToListAsync();

                return NotFound($"\"{category}\" kategorisinde skor bulunamadı. Mevcut kategoriler: {string.Join(", ", availableCategories)}");
            }

            return scores;
        }

        [HttpPost]
        public async Task<ActionResult<Score>> Create(Score score)
        {
            score.Datetime = DateTime.Now;
            _context.Scores.Add(score);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = score.ScoreId }, score);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Score score)
        {
            if (id != score.ScoreId)
            {
                return BadRequest();
            }

            score.Datetime = DateTime.Now;
            _context.Entry(score).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ScoreExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var score = await _context.Scores.FindAsync(id);
            if (score == null)
            {
                return NotFound();
            }

            _context.Scores.Remove(score);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ScoreExists(int id)
        {
            return _context.Scores.Any(e => e.ScoreId == id);
        }
    }
}
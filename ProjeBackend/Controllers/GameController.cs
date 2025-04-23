using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjeBackend.Models;

namespace ProjeBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GamesController : ControllerBase
    {
        private readonly ApiDbContext _context;

        public GamesController(ApiDbContext context)
        {
            _context = context;
        }

        // GET: api/Games
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Game>>> GetGames()
        {
            return await _context.Games
                .Include(g => g.Cards)   // Kartlar dahil
                .Include(g => g.User)    // Kullanıcı dahil
                .ToListAsync();
        }

        // GET: api/Games/5
        [HttpGet("{userId}")]
        public async Task<ActionResult<IEnumerable<Game>>> GetGame(int userId)
        {
            var games = await _context.Games
                .Include(g => g.Cards)  // Kartlar dahil
                .Include(g => g.User)   // Kullanıcı dahil
                .Where(g => g.UserId == userId).ToListAsync();

            if (games == null || games.Count == 0)
            {
                return NotFound();
            }

            return games;
        }

        // POST: api/Games
        [HttpPost]
        public async Task<ActionResult<Game>> PostGame(Game game)
        {
            _context.Games.Add(game);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetGame), new { id = game.Id }, game);
        }

        [HttpPost("UploadGame")]
        public async Task<IActionResult> UploadGame([FromForm] UploadGameRequest request)
        {
            // 1. Oyun görselini kaydet
            var uploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/images/games");
            if (!Directory.Exists(uploadsDir))
                Directory.CreateDirectory(uploadsDir);

            var gameImageName = Guid.NewGuid() + Path.GetExtension(request.GameImage.FileName);
            var gameImagePath = Path.Combine(uploadsDir, gameImageName);

            using (var stream = new FileStream(gameImagePath, FileMode.Create))
            {
                await request.GameImage.CopyToAsync(stream);
            }

            // 2. Game nesnesini oluştur
            var game = new Game
            {
                Name = request.Name,
                Description = request.Description,
                Round = request.Round,
                ImagePath = $"images/games/{gameImageName}",
                UserId = request.UserId,
                Cards = new List<Card>()
            };

            // 3. Kartları ekle
            var cardUploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/images/cards");
            if (!Directory.Exists(cardUploadsDir))
                Directory.CreateDirectory(cardUploadsDir);

            foreach (var cardItem in request.Cards)
            {
                var cardImageName = Guid.NewGuid() + Path.GetExtension(cardItem.File.FileName);
                var cardImagePath = Path.Combine(cardUploadsDir, cardImageName);

                using (var stream = new FileStream(cardImagePath, FileMode.Create))
                {
                    await cardItem.File.CopyToAsync(stream);
                }

                game.Cards.Add(new Card
                {
                    Name = cardItem.Name,
                    ImagePath = $"images/cards/{cardImageName}",
                    GameId = cardItem.GameId,
                });
            }

            // 4. Veritabanına ekle
            _context.Games.Add(game);
            await _context.SaveChangesAsync();

            return Ok(game);
        }


        // PUT: api/Games/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutGame(int id, Game game)
        {
            if (id != game.Id)
                return BadRequest("ID uyuşmuyor.");

            _context.Entry(game).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!GameExists(id))
                    return NotFound();

                throw;
            }

            return NoContent();
        }

        // DELETE: api/Games/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteGame(int id)
        {
            var game = await _context.Games.FindAsync(id);
            if (game == null)
                return NotFound();

            _context.Games.Remove(game);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool GameExists(int id)
        {
            return _context.Games.Any(e => e.Id == id);
        }
    }
}

using Microsoft.AspNetCore.Authorization.Infrastructure;
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

            if(request.GameImage == null){
                return BadRequest("Oyun kayıt edilirken GameImage null olamaz!");
            }

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
                PlayCount = 0,
                Cards = new List<Card>()
            };

            // 3. Kartları ekle
            var cardUploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/images/cards");
            if (!Directory.Exists(cardUploadsDir))
                Directory.CreateDirectory(cardUploadsDir);

            foreach (var cardItem in request.Cards)
            {
                if(cardItem.File == null){
                    return BadRequest("Oyun kayıt edilirken Card.File null olamaz!");
                }
                
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
                    WinCount = 0,
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

        [HttpPut("UpdatePlayCount/{id}")]
        public async Task<IActionResult> UpdatePlayCount(int id, [FromBody] int newPlayCount)
        {
            var game = await _context.Games.FindAsync(id);
            if (game == null)
            {
                return NotFound(new { message = "Game not found." });
            }

            game.PlayCount = newPlayCount;

            try
            {
                await _context.SaveChangesAsync();
                return Ok(new { message = "PlayCount updated successfully.", playCount = game.PlayCount });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while updating PlayCount.", error = ex.Message });
            }
        }


        [HttpPost("Update/{id}")]
        public async Task<IActionResult> UpdateGame(int id, UploadGameRequest gameRequest)
        {
            var game = await _context.Games.FindAsync(id);
            if (game == null)
            {
                return NotFound(new { message = "Game not found." });
            }

            game.Description = gameRequest.Description;
            game.Name = gameRequest.Name;
            game.Round = gameRequest.Round;

            // ✅ Game Image varsa güncelle
            if (gameRequest.GameImage != null && gameRequest.GameImage.Length > 0)
            {
                var gameImageUploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/images/games");
                if (!Directory.Exists(gameImageUploadsDir))
                    Directory.CreateDirectory(gameImageUploadsDir);

                var gameImagePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot",game.ImagePath);

                // Eski dosyayı sil
                if (!string.IsNullOrEmpty(gameImagePath))
                {
                    var existingGameImagePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", game.ImagePath);
                    if (System.IO.File.Exists(existingGameImagePath))
                        System.IO.File.Delete(existingGameImagePath);
                }

                // Yeni resmi kaydet
                var gameImageName = Guid.NewGuid() + Path.GetExtension(gameRequest.GameImage.FileName);
                var newGameImagePath = Path.Combine(gameImageUploadsDir, gameImageName);
                using (var stream = new FileStream(newGameImagePath, FileMode.Create))
                {
                    await gameRequest.GameImage.CopyToAsync(stream);
                }

                game.ImagePath = $"images/games/{gameImageName}";
            }


            foreach (var card in gameRequest.Cards)
            {
                
                if(card.id != -1){ // -1 yeni eklenen kartlar için

                    //var olan kartları güncelle
                    var existingCard = await _context.Card.FindAsync(card.id);

                    if (existingCard == null) continue;

                    existingCard.Name = card.Name;

                    if (card.File != null && card.File.Length > 0){
                        var cardUploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/images/cards");
                        if (!Directory.Exists(cardUploadsDir))
                            Directory.CreateDirectory(cardUploadsDir);

                        // 💥 ESKİ GÖRSELİ SİL
                        if (!string.IsNullOrEmpty(existingCard.ImagePath))
                        {
                            var oldImageFullPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", existingCard.ImagePath);
                            if (System.IO.File.Exists(oldImageFullPath))
                            {
                                System.IO.File.Delete(oldImageFullPath);
                            }
                        }

                        // 📷 YENİ GÖRSELİ KAYDET
                        string cardImageName = Guid.NewGuid() + Path.GetExtension(card.File.FileName);
                        var cardImagePath = Path.Combine(cardUploadsDir, cardImageName);

                        using (var stream = new FileStream(cardImagePath, FileMode.Create))
                        {
                            await card.File.CopyToAsync(stream);
                        }

                        existingCard.ImagePath = $"images/cards/{cardImageName}";
                    }
                }
                else{
                    // yeni kart ekle

                    var cardUploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/images/cards");
                    if (!Directory.Exists(cardUploadsDir))
                        Directory.CreateDirectory(cardUploadsDir);

                    if(card.File == null){
                        return BadRequest("Yeni kart eklenecek. Card.File null olamaz!");
                    }
                    // 📷 YENİ GÖRSELİ KAYDET
                    var cardImageName = Guid.NewGuid() + Path.GetExtension(card.File.FileName);
                    var cardImagePath = Path.Combine(cardUploadsDir, cardImageName);

                    using (var stream = new FileStream(cardImagePath, FileMode.Create))
                    {
                        await card.File.CopyToAsync(stream);
                    }
                    if(game.Cards == null)
                        game.Cards = new List<Card>();
                    game.Cards.Add(new Card{
                        Name = card.Name,
                        WinCount = 0,
                        GameId = id,
                        ImagePath = Path.Combine("images/cards", cardImageName),
                    }
                    );

                }
            }
            if(gameRequest.DeleteCardsId != null && gameRequest.DeleteCardsId.Count > 0 ){
                foreach( var cardId in gameRequest.DeleteCardsId){
                    var card = await _context.Card.FindAsync(cardId);
                    if(card == null){
                        continue;
                    }
                    if (!string.IsNullOrEmpty(card.ImagePath))
                    {
                        var oldImageFullPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", card.ImagePath);
                        if (System.IO.File.Exists(oldImageFullPath))
                        {
                            System.IO.File.Delete(oldImageFullPath);
                        }
                    }
                    _context.Card.Remove(card);
                }
            }

            try
            {
                await _context.SaveChangesAsync();
                return Ok(new { message = "Game updated successfully.", game});
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while updating game.", error = ex.Message });
            }
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

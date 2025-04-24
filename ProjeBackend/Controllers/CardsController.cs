using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjeBackend;
using ProjeBackend.Models;

namespace ProjeBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CardsController : ControllerBase
    {
        private readonly ApiDbContext _context;

        public CardsController(ApiDbContext context)
        {
            _context = context;
        }

        // GET: api/Cards
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Card>>> GetCard()
        {
            return await _context.Card.ToListAsync();
        }

        // GET: api/Cards/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Card>> GetCard(int id)
        {
            var card = await _context.Card.FindAsync(id);

            if (card == null)
            {
                return NotFound();
            }

            return card;
        }

        // PUT: api/Cards/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCard(int id, Card card)
        {
            if (id != card.Id)
            {
                return BadRequest();
            }

            _context.Entry(card).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CardExists(id))
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

        [HttpPut("UpdateWinAndPlayCount/{cardId}")]
        public async Task<IActionResult> UpdateWinAndPlayCount(int cardId, [FromBody] int newWinCount)
        {
            var card = await _context.Card.FindAsync(cardId);

            if (card == null)
            {
                return NotFound(new { message = "Card not found." });
            }

            // WinCount güncelleniyor
            card.WinCount = newWinCount;

            // Kartın ait olduğu Game nesnesi getiriliyor
            var game = await _context.Games.FindAsync(card.GameId);

            if (game == null)
            {
                return NotFound(new { message = "Related game not found." });
            }

            // PlayCount 1 artırılıyor
            game.PlayCount += 1;

            try
            {
                await _context.SaveChangesAsync();
                return Ok(new
                {
                    message = "WinCount and PlayCount updated successfully.",
                    cardId = card.Id,
                    updatedWinCount = card.WinCount,
                    updatedPlayCount = game.PlayCount
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error while updating.", error = ex.Message });
            }
        }


        // POST: api/Cards
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Card>> PostCard(Card card)
        {
            _context.Card.Add(card);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCard", new { id = card.Id }, card);
        }

        [HttpPost("UploadCard")]
        public async Task<ActionResult<Card>> UploadCard([FromForm] UploadCardRequest request)
        {
            if (request.File == null || request.File.Length == 0)
                return BadRequest("Dosya seçilmedi!");

            // Dosya adı + sunucu dizini
            var uploadsDir = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/images/cards");
            if (!Directory.Exists(uploadsDir))
                Directory.CreateDirectory(uploadsDir);

            var uniqueFileName = Guid.NewGuid().ToString() + Path.GetExtension(request.File.FileName);
            var filePath = Path.Combine(uploadsDir, uniqueFileName);

            // Dosyayı kaydet
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await request.File.CopyToAsync(stream);
            }

            // DB'ye kayıt
            var card = new Card
            {
                Name = request.Name,
                GameId = request.GameId,
                ImagePath = $"images/cards/{uniqueFileName}"  // sadece yol!
            };

            _context.Card.Add(card);
            await _context.SaveChangesAsync();

            return Ok(card);
        }


        // DELETE: api/Cards/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCard(int id)
        {
            var card = await _context.Card.FindAsync(id);
            if (card == null)
            {
                return NotFound();
            }

            _context.Card.Remove(card);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CardExists(int id)
        {
            return _context.Card.Any(e => e.Id == id);
        }
    }
}

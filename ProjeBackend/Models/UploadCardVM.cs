using Microsoft.AspNetCore.Mvc;

public class UploadCardRequest
{
    [FromForm]
    public required IFormFile File { get; set; }

    [FromForm]
    public required string Name { get; set; }

    [FromForm]
    public int GameId { get; set; }

    public int WinCount { get; set; }
}

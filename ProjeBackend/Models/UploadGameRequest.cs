using Microsoft.AspNetCore.Mvc;


public class UploadGameRequest
{
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public int Round { get; set; }
    public int PlayCount { get; set; }
    
    [FromForm]
    public IFormFile? GameImage { get; set; }
    public int UserId { get; set; }

    public List<UploadCardRequest> Cards { get; set; } = new();
}

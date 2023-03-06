public class HomeController : Controller
{
    public IActionResult Index()
    {
        return View();
    }

    [HttpPost]
    public IActionResult GenerateMeme(string topText, string bottomText, string imageUrl)
    {
        // Here we could use a library like ImageSharp or Magick.NET to generate the meme image
        // using the provided top and bottom text and image URL

        // Once we've generated the meme image, we could return it as a FileResult:
        // return File(memeImageStream, "image/jpeg");

        // Alternatively, we could save the meme image to disk and redirect to a "success" page:
        // return RedirectToAction("MemeGenerated", new { memeImageUrl = "/memes/123.jpg" });

        // For this example, we'll just return a view that displays the generated meme data:
        var model = new MemeViewModel
        {
            TopText = topText,
            BottomText = bottomText,
            ImageUrl = imageUrl,
        };

        return View("MemeGenerated", model);
    }
}

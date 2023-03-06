public class ImagesController : Controller
{
    private readonly IMemeRepository _memeRepository;

    public ImagesController(IMemeRepository memeRepository)
    {
        _memeRepository = memeRepository;
    }

    public IActionResult Index()
    {
        var memes = _memeRepository.GetAllMemes();
        var model = memes.Select(m => new MemeViewModel
        {
            Id = m.Id,
            Name = m.Name,
            ImageUrl = m.ImageUrl
        });

        return View(model);
    }

    public IActionResult Create()
    {
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Create(MemeViewModel model, IFormFile imageFile)
    {
        if (ModelState.IsValid)
        {
            // Save the image file to disk or a cloud storage service like AWS S3
            var imageUrl = await _memeRepository.UploadImageAsync(imageFile);

            // Create the meme entity and save it to the database
            var meme = new Meme
            {
                Name = model.Name,
                ImageUrl = imageUrl
            };
            _memeRepository.AddMeme(meme);
            await _memeRepository.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        return View(model);
    }

    public IActionResult Edit(int id)
    {
        var meme = _memeRepository.GetMemeById(id);
        if (meme == null)
        {
            return NotFound();
        }

        var model = new MemeViewModel
        {
            Id = meme.Id,
            Name = meme.Name,
            ImageUrl = meme.ImageUrl
        };

        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(int id, MemeViewModel model, IFormFile imageFile)
    {
        var meme = _memeRepository.GetMemeById(id);
        if (meme == null)
        {
            return NotFound();
        }

        if (ModelState.IsValid)
        {
            if (imageFile != null)
            {
                // Save the new image file to disk or a cloud storage service like AWS S3
                var imageUrl = await _memeRepository.UploadImageAsync(imageFile);
                meme.ImageUrl = imageUrl;
            }

            // Update the meme entity and save it to the database
            meme.Name = model.Name;
            _memeRepository.UpdateMeme(meme);
            await _memeRepository.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> Delete(int id)
    {
        var meme = _memeRepository.GetMemeById(id);
        if (meme == null)
        {
            return NotFound();
        }

        // Delete the meme entity and its image from the database and storage
        await _memeRepository.DeleteMemeAsync(meme);

        return RedirectToAction(nameof(Index));
    }
}

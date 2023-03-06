public class TextsController : Controller
{
    private readonly IMemeRepository _memeRepository;

    public TextsController(IMemeRepository memeRepository)
    {
        _memeRepository = memeRepository;
    }

    [HttpGet]
    public IActionResult Create(int memeId)
    {
        var meme = _memeRepository.GetMemeById(memeId);
        if (meme == null)
        {
            return NotFound();
        }

        var model = new MemeTextViewModel
        {
            MemeId = memeId,
            TopText = "",
            BottomText = ""
        };

        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> Create(MemeTextViewModel model)
    {
        var meme = _memeRepository.GetMemeById(model.MemeId);
        if (meme == null)
        {
            return NotFound();
        }

        if (ModelState.IsValid)
        {
            // Create the MemeText entity and save it to the database
            var memeText = new MemeText
            {
                MemeId = model.MemeId,
                TopText = model.TopText,
                BottomText = model.BottomText
            };
            _memeRepository.AddMemeText(memeText);
            await _memeRepository.SaveChangesAsync();

            return RedirectToAction("Edit", "Memes", new { id = model.MemeId });
        }

        return View(model);
    }

    [HttpGet]
    public IActionResult Edit(int id)
    {
        var memeText = _memeRepository.GetMemeTextById(id);
        if (memeText == null)
        {
            return NotFound();
        }

        var model = new MemeTextViewModel
        {
            Id = memeText.Id,
            MemeId = memeText.MemeId,
            TopText = memeText.TopText,
            BottomText = memeText.BottomText
        };

        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(int id, MemeTextViewModel model)
    {
        var memeText = _memeRepository.GetMemeTextById(id);
        if (memeText == null)
        {
            return NotFound();
        }

        if (ModelState.IsValid)
        {
            // Update the MemeText entity and save it to the database
            memeText.TopText = model.TopText;
            memeText.BottomText = model.BottomText;
            _memeRepository.UpdateMemeText(memeText);
            await _memeRepository.SaveChangesAsync();

            return RedirectToAction("Edit", "Memes", new { id = memeText.MemeId });
        }

        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> Delete(int id)
    {
        var memeText = _memeRepository.GetMemeTextById(id);
        if (memeText == null)
        {
            return NotFound();
        }

        // Delete the MemeText entity from the database
        _memeRepository.DeleteMemeText(memeText);
        await _memeRepository.SaveChangesAsync();

        return RedirectToAction("Edit", "Memes", new { id = memeText.MemeId });
    }
}

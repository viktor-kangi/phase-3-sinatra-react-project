public class UsersController : Controller
{
    private readonly IUserRepository _userRepository;

    public UsersController(IUserRepository userRepository)
    {
        _userRepository = userRepository;
    }

    [HttpGet]
    public IActionResult Register()
    {
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Register(RegisterViewModel model)
    {
        if (ModelState.IsValid)
        {
            // Create the User entity and save it to the database
            var user = new User
            {
                Username = model.Username,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(model.Password),
                Email = model.Email
            };
            _userRepository.AddUser(user);
            await _userRepository.SaveChangesAsync();

            return RedirectToAction("Login", "Auth");
        }

        return View(model);
    }

    [HttpGet]
    public IActionResult Edit(int id)
    {
        var user = _userRepository.GetUserById(id);
        if (user == null)
        {
            return NotFound();
        }

        var model = new EditUserViewModel
        {
            Id = user.Id,
            Username = user.Username,
            Email = user.Email
        };

        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(int id, EditUserViewModel model)
    {
        var user = _userRepository.GetUserById(id);
        if (user == null)
        {
            return NotFound();
        }

        if (ModelState.IsValid)
        {
            // Update the User entity and save it to the database
            user.Username = model.Username;
            user.Email = model.Email;
            _userRepository.UpdateUser(user);
            await _userRepository.SaveChangesAsync();

            return RedirectToAction("Index", "Home");
        }

        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> Delete(int id)
    {
        var user = _userRepository.GetUserById(id);
        if (user == null)
        {
            return NotFound();
        }

        // Delete the User entity from the database
        _userRepository.DeleteUser(user);
        await _userRepository.SaveChangesAsync();

        return RedirectToAction("Index", "Home");
    }
}

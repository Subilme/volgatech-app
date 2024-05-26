using volgatech_server.Models.Dto;
using volgatech_server.Models.Requests.UserRequests;
using volgatech_server.Utils;
using volgatech_server.Context;
using volgatech_server.Context.Models;
using Microsoft.AspNetCore.Mvc;
using System.Security.Cryptography;

namespace volgatech_server.Controllers
{
    [ApiController]
    [Route("api/user")]
    public class UserController : ControllerBase
    {
        private readonly IServiceScopeFactory _serviceScopeFactory;

        public UserController(IServiceScopeFactory serviceScopeFactory)
        {
            _serviceScopeFactory = serviceScopeFactory;
        }

        [HttpPost("register")]
        public IActionResult Register([FromBody] RegisterRequestDto request)
        {
            try
            {
                using IServiceScope scope = _serviceScopeFactory.CreateScope();
                LaboratoryDbContext context = scope.ServiceProvider.GetRequiredService<LaboratoryDbContext>();

                var user = !string.IsNullOrWhiteSpace(request.login) ? FindUserByLogin(context, request.login) : null;
                if (user != null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Аккаунт уже зарегистрирован",
                    });
                }

                (string passwordSalt, string passwordHash) = PasswordUtils.CreatePasswordHash(request.password);

                var newUser = new User()
                {
                    Name = request.name,
                    Login = request.login,
                    UserRole = request.userRole,
                    PasswordSalt = passwordSalt,
                    PasswordHash = passwordHash,
                };
                context.Users.Add(newUser);
                context.SaveChanges();

                var token = GetUserAccessToken(context, newUser);
                return Ok(new ResponseDto<string>()
                {
                    Success = true,
                    Data = token,
                });
            }
            catch
            {
                return Ok(new ResponseDto<dynamic>()
                {
                    Success = false,
                });
            }
        }

        [HttpPost("auth")]
        public IActionResult Login([FromBody] LoginRequestDto request)
        {
            try
            {
                using IServiceScope scope = _serviceScopeFactory.CreateScope();
                LaboratoryDbContext context = scope.ServiceProvider.GetRequiredService<LaboratoryDbContext>();

                var user = !string.IsNullOrWhiteSpace(request.login) ? FindUserByLogin(context, request.login) : null;
                if (user == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Пользователь не найден",
                    });
                }

                if (!PasswordUtils.VerifyPassword(request.password, user.PasswordSalt, user.PasswordHash))
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Неверный пароль",
                    });
                }

                var token = GetUserAccessToken(context, user);
                return Ok(new ResponseDto<string>()
                {
                    Success = true,
                    Data = token,
                });
            }
            catch
            {
                return Ok(new ResponseDto<dynamic>()
                {
                    Success = false,
                });
            }
        }

        [HttpGet("profile")]
        public IActionResult GetUserData([FromQuery] string accessToken)
        {
            try
            {
                using IServiceScope scope = _serviceScopeFactory.CreateScope();
                LaboratoryDbContext context = scope.ServiceProvider.GetRequiredService<LaboratoryDbContext>();

                var userId = context.AccessTokens.FirstOrDefault(x => x.Token == accessToken)?.UserId;
                if (userId == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        InvalidAccessToken = true,
                    });
                }

                var user = context.Users.FirstOrDefault(x => x.UserId == userId);
                if (user == null)
                {
                    return Ok(new ResponseDto<dynamic>()
                    {
                        Success = false,
                        Error = "Пользователь не найден",
                    });
                }

                return Ok(new ResponseDto<UserDto>()
                {
                    Success = true,
                    Data = new UserDto()
                    {
                        UserId = user.UserId,
                        Name = user.Name,
                        Login = user.Login,
                        UserRole = user.UserRole,
                    },
                });
            }
            catch
            {
                return Ok(new ResponseDto<dynamic>()
                {
                    Success = false,
                });
            }
        }

        private User? FindUserByLogin(LaboratoryDbContext context, string login)
        {
            return context.Users.FirstOrDefault(x => x.Login == login);
        }

        private string GetUserAccessToken(LaboratoryDbContext context, User user)
        {
            var accessToken = context.AccessTokens.FirstOrDefault(x => x.UserId == user.UserId);
            if (accessToken == null)
            {
                using (var rng = new RNGCryptoServiceProvider())
                {
                    var bytes = new byte[27];
                    rng.GetBytes(bytes);
                    var token = Convert.ToBase64String(bytes);
                    var newToken = new AccessToken()
                    {
                        UserId = user.UserId,
                        Token = token,
                    };

                    context.AccessTokens.Add(newToken);
                    context.SaveChanges();

                    return newToken.Token;
                }
            }

            return accessToken.Token;
        }
    }
}

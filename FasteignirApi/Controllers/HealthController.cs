using FasteignirApi.Services;
using FasteignirCommon.EF;
using Microsoft.AspNetCore.Mvc;

namespace FasteignirApi.Controllers
{
    [ApiController]
    [Route("/")]
    public class HealthController : ControllerBase
    {
        [HttpGet]
        public ActionResult<List<Kaupskra>> Get() => Ok($"Hello World {Environment.GetEnvironmentVariable("POSTGRES_PASSWORD") ?? "i´m a teapot"}");

    }
}
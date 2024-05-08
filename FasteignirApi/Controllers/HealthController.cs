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
        public ActionResult<string> Get() => Ok($"Hello World ");

    }
}
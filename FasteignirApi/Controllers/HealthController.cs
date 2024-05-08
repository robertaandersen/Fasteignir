using FasteignirApi.Data;
using FasteignirApi.Services;
using FasteignirCommon.EF;
using Microsoft.AspNetCore.Mvc;

namespace FasteignirApi.Controllers
{
    [ApiController]
    [Route("/")]
    public class HealthController : ControllerBase
    {
        private readonly KaupskraRepo _kaupskraRepo;

        public HealthController(KaupskraRepo kaupskraRepo) => _kaupskraRepo = kaupskraRepo;

        [HttpGet]
        public ActionResult<string> Get() => Ok($"Hello World ");

        [HttpGet("/dbhealth")]
        public ActionResult<string> DbHealth()
        {

            try
            {
                var count = _kaupskraRepo.IsConnected();
                return Ok($"Connected to database, found {count} records");
            }
            catch (Exception e)
            {
                return StatusCode(500, $"Failed to connect to database, {e.Message}");
            }

        }

    }
}
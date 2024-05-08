using FasteignirApi.Services;
using FasteignirCommon.EF;
using Microsoft.AspNetCore.Mvc;

namespace FasteignirApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class KaupskraController : ControllerBase
    {
        private readonly KaupskraService kaupskraService;

        public KaupskraController(KaupskraService kaupskraService) => this.kaupskraService = kaupskraService;

        [HttpGet]
        public ActionResult<List<Kaupskra>> Get(
            string? name,
            string? postNumer,
            int? fermetrarFra,
            int? fermetrarTil,
            long? kaupverdFra,
            long? kaupverdTil,
            int? herbergiFra,
            int? herbergiTil,
            DateTime? thinglystFra,
            DateTime? thinglystTil,
            int? byggingarFra,
            int? byggingarTil)
        {
            if (string.IsNullOrEmpty(name) &&
                string.IsNullOrEmpty(postNumer) &&
                fermetrarFra == null &&
                fermetrarTil == null &&
                kaupverdFra == null &&
                kaupverdTil == null &&
                herbergiFra == null &&
                herbergiTil == null &&
                thinglystFra == null &&
                thinglystTil == null &&
                byggingarFra == null &&
                byggingarTil == null)
            {
                return new List<Kaupskra>();
            }
            var res = kaupskraService.FetchKaupskra(SanitizeString(name), SanitizeString(postNumer)?.Split(",").Select(x => int.Parse(x.Trim())).ToList(), fermetrarFra, fermetrarTil, kaupverdFra, kaupverdTil, herbergiFra, herbergiTil, thinglystFra, thinglystTil, byggingarFra, byggingarTil).ToList();
            return Ok(res);
        }


        private static string? SanitizeString(string? stringVal) => stringVal?.Trim();
    }
}
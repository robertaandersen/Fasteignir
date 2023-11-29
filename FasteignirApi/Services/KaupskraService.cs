
using FasteignirApi.Data;
using FasteignirCommon.EF;

namespace FasteignirApi.Services
{
    public class KaupskraService
    {
        private readonly KaupskraRepo _kaupskraRepo;

        public KaupskraService(KaupskraRepo kaupskraRepo) => _kaupskraRepo = kaupskraRepo;

        internal List<Kaupskra> FetchKaupskra(
            string? name,
            List<int>? postNumer,
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
            var baseQuery = _kaupskraRepo.FetchAll();
            if (!string.IsNullOrEmpty(name)) baseQuery = baseQuery?.Where(x => x.Heimilisfang.ToLower().Contains(name.ToLower()));
            if (postNumer != null && postNumer.Any()) baseQuery = baseQuery?.Where(x => x.Postnr != null && postNumer.Contains(x.Postnr.Value));
            if (fermetrarFra != null) baseQuery = baseQuery?.Where(x => x.Einflm >= fermetrarFra);
            if (fermetrarTil != null) baseQuery = baseQuery?.Where(x => x.Einflm <= fermetrarTil);
            if (kaupverdFra != null) baseQuery = baseQuery?.Where(x => x.Kaupverd >= kaupverdFra);
            if (kaupverdTil != null) baseQuery = baseQuery?.Where(x => x.Kaupverd <= kaupverdTil);
            if (herbergiFra != null) baseQuery = baseQuery?.Where(x => x.Fjherb >= herbergiFra);
            if (herbergiTil != null) baseQuery = baseQuery?.Where(x => x.Fjherb <= herbergiTil);
            if (thinglystFra != null) baseQuery = baseQuery?.Where(x => x.Thinglystdags >= thinglystFra);
            if (thinglystTil != null) baseQuery = baseQuery?.Where(x => x.Thinglystdags <= thinglystTil);
            if (byggingarFra != null) baseQuery = baseQuery?.Where(x => x.Byggar >= byggingarFra);
            if (byggingarTil != null) baseQuery = baseQuery?.Where(x => x.Byggar <= byggingarTil);
            return baseQuery?.ToList() ?? new();
        }
    }
}
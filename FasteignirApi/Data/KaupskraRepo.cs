using FasteignirCommon.EF;

namespace FasteignirApi.Data
{
    public class KaupskraRepo
    {
        private FasteignaskraContext _fasteignaskraContext;
        public KaupskraRepo(FasteignaskraContext fasteignaskraContext) => _fasteignaskraContext = fasteignaskraContext;
        internal IQueryable<Kaupskra> FetchAll() => _fasteignaskraContext.Kaupskras;
        internal int IsConnected() => _fasteignaskraContext.Kaupskras.Count();
    }
}

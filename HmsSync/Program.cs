using FasteignirCommon.EF;
using Microsoft.EntityFrameworkCore;



string path = Directory.GetCurrentDirectory();
using var reader = new StreamReader($"{path}/kaupskra.csv", System.Text.Encoding.GetEncoding("iso-8859-1"));
int i = 0;
List<Kaupskra> kaupskras = new();
while (reader?.Peek() >= 0)
{
    string? text = reader! != null ? await reader.ReadLineAsync() : null;
    if (i == 0)
    {
        i++;
        continue;
    }
    var line = text?.Split(';')!;
    kaupskras.Add(new Kaupskra
    {
        Id = Guid.NewGuid(),
        Faerslunumer = int.Parse(line[0]),
        Emnr = int.Parse(line[1]),
        Skjalanumer = line[2],
        Fastnum = int.Parse(line[3]),
        Heimilisfang = line[4],
        Postnr = int.Parse(line[5]),
        Heinum = int.Parse(line[6]),
        Svfn = line[7],
        Sveitarfelag = line[8].Trim(),
        Utgdag = DateTime.Parse(line[9]),
        Thinglystdags = DateTime.Parse(line[10]),
        Kaupverd = long.Parse(line[11]) * 1000,
        Fasteignamat = long.Parse(line[12]) * 1000,
        FasteignamatGildandi = string.IsNullOrEmpty(line[13].Trim()) ? null : long.Parse(line[13]) * 1000,
        BrunabotamatGildandi = string.IsNullOrEmpty(line[14]) ? null : long.Parse(line[14]) * 1000,
        Byggar = !string.IsNullOrEmpty(line[15].Trim()) ? int.Parse(line[15].Trim()) : null,
        Fepilog = line[16],
        Einflm = string.IsNullOrEmpty(line[17].Trim()) ? null : decimal.Parse(line[17].Replace(".", ",").Trim()),
        LodFlm = string.IsNullOrEmpty(line[18]) ? null : decimal.Parse(line[18].Replace(".", ",").Trim()),
        LodFlmein = line[19],
        Fjherb = string.IsNullOrEmpty(line[20]) ? null : int.Parse(line[20]),
        Tegund = line[21],
        Fullbuid = int.Parse(line[22]) == 1,
        OnothaefurSamningur = int.Parse(line[23]) == 1
    });
}

var optionsBuilder = new DbContextOptionsBuilder<FasteignaskraContext>();
optionsBuilder.UseNpgsql("Host=localhost;Username=admin;Password=admin;Database=admin");
using var dbContext = new FasteignaskraContext(optionsBuilder.Options);

dbContext.Kaupskras.AddRange(kaupskras);
dbContext.SaveChanges();
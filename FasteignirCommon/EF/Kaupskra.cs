using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace FasteignirCommon.EF;

[Table("kaupskra", Schema = "dbo")]
public partial class Kaupskra
{
    [Key]
    [Column("id")]
    public Guid Id { get; set; }

    [Column("faerslunumer")]
    public int? Faerslunumer { get; set; }

    [Column("emnr")]
    public int? Emnr { get; set; }

    [Column("skjalanumer")]
    [StringLength(255)]
    public string? Skjalanumer { get; set; }

    [Column("fastnum")]
    public int? Fastnum { get; set; }

    [Column("heimilisfang")]
    [StringLength(255)]
    public string Heimilisfang { get; set; } = null!;

    [Column("postnr")]
    public int? Postnr { get; set; }

    [Column("heinum")]
    public int? Heinum { get; set; }

    [Column("svfn")]
    [StringLength(50)]
    public string? Svfn { get; set; }

    [Column("sveitarfelag")]
    [StringLength(50)]
    public string? Sveitarfelag { get; set; }

    [Column("utgdag", TypeName = "timestamp without time zone")]
    public DateTime? Utgdag { get; set; }

    [Column("thinglystdags", TypeName = "timestamp without time zone")]
    public DateTime? Thinglystdags { get; set; }

    [Column("kaupverd")]
    public long? Kaupverd { get; set; }

    [Column("fasteignamat")]
    public long? Fasteignamat { get; set; }

    [Column("fasteignamat_gildandi")]
    public long? FasteignamatGildandi { get; set; }

    [Column("brunabotamat_gildandi")]
    public long? BrunabotamatGildandi { get; set; }

    [Column("byggar")]
    public int? Byggar { get; set; }

    [Column("fepilog")]
    [StringLength(50)]
    public string? Fepilog { get; set; }

    [Column("einflm")]
    public decimal? Einflm { get; set; }

    [Column("lod_flm")]
    public decimal? LodFlm { get; set; }

    [Column("lod_flmein")]
    [StringLength(50)]
    public string? LodFlmein { get; set; }

    [Column("fjherb")]
    public int? Fjherb { get; set; }

    [Column("tegund")]
    [StringLength(50)]
    public string? Tegund { get; set; }

    [Column("fullbuid")]
    public bool? Fullbuid { get; set; }

    [Column("onothaefur_samningur")]
    public bool? OnothaefurSamningur { get; set; }
}

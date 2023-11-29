using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace FasteignirCommon.EF;

public partial class FasteignaskraContext : DbContext
{
    public FasteignaskraContext(DbContextOptions<FasteignaskraContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Kaupskra> Kaupskras { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Kaupskra>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("kaupskra_pkey");

            entity.Property(e => e.Id).ValueGeneratedNever();
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}

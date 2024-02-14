﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace HistoryDb.Migrations;

[DbContext(typeof(HistoryDbContext))]
partial class HistoryDbContextModelSnapshot : ModelSnapshot
{
    protected override void BuildModel(ModelBuilder modelBuilder)
    {
#pragma warning disable 612, 618
        modelBuilder
            .HasAnnotation("ProductVersion", "8.0.0")
            .HasAnnotation("Relational:MaxIdentifierLength", 63);

        NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

        modelBuilder.HasSequence("history_hilo")
            .IncrementsBy(10);

        modelBuilder.Entity("HistoryItem", b =>
            {
                b.Property<int>("Id")
                    .ValueGeneratedOnAdd()
                    .HasColumnType("integer");

                NpgsqlPropertyBuilderExtensions.UseHiLo(b.Property<int>("Id"), "history_hilo");

                b.Property<string>("ContentId")
                    .HasMaxLength(1024)
                    .HasColumnType("character varying(1024)");

                b.Property<string>("Description")
                    .HasMaxLength(2048)
                    .HasColumnType("character varying(2048)");

                b.Property<string>("SourceUrl")
                    .HasMaxLength(1024)
                    .HasColumnType("character varying(1024)");

                b.Property<DateTime>("Timestamp")
                    .HasColumnType("timestamp with time zone");

                b.Property<string>("Type")
                    .IsRequired()
                    .HasMaxLength(100)
                    .HasColumnType("character varying(100)");

                b.HasKey("Id");

                b.ToTable("History", (string)null);
            });
#pragma warning restore 612, 618
    }
}

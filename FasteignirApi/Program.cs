using FasteignirApi.Data;
using FasteignirApi.Services;
using FasteignirCommon.EF;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
    {
        Title = "Your Web API",
        Version = "v1"
    });
});

builder.Services.AddScoped<KaupskraService>();
builder.Services.AddScoped<KaupskraRepo>();
var hostName = Environment.GetEnvironmentVariable("POSTGRES_HOST") ?? "localhost";
var userName = Environment.GetEnvironmentVariable("POSTGRES_USER") ?? "admin";
var password = Environment.GetEnvironmentVariable("POSTGRES_PASS") ?? "admin";
var connectionString = $"Host={hostName};Username={userName};Password={password};Database=fasteignir";
builder.Services.AddDbContext<FasteignaskraContext>(options => options.UseNpgsql(connectionString));

var app = builder.Build();

// Configure the HTTP request pipeline.


app.UseSwagger();
app.UseSwaggerUI();


app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

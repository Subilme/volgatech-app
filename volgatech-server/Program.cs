using Microsoft.EntityFrameworkCore;
using volgatech_server.Context;

namespace volgatech_server
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            var connectinoString = builder.Configuration.GetConnectionString("DefaultConnection");
            builder.Services.AddDbContext<LaboratoryDbContext>(options =>
            {
                options.UseMySql(connectinoString, ServerVersion.AutoDetect(connectinoString));
            });

            builder.Services.AddControllers()
                .AddNewtonsoftJson(x => x.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore);
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            app.Run("http://*:80");
        }
    }
}

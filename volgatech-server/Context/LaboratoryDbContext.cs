using Microsoft.EntityFrameworkCore;
using volgatech_server.Context.Models;
using File = volgatech_server.Context.Models.File;

namespace volgatech_server.Context
{
    public class LaboratoryDbContext : DbContext
    {
        public DbSet<AccessToken> AccessTokens { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<BundleInfo> BundleInfos { get; set; }
        public DbSet<Bundle> Bundles { get; set; }
        public DbSet<BundleItemInfo> BundleItemInfos { get; set; }
        public DbSet<BundleItem> BundleItems { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<Project> Projects { get; set; }
        public DbSet<File> Files { get; set; }
        public DbSet<Storage> Storages { get; set; }
        public DbSet<Responsible> Responsibles { get; set; }

        public LaboratoryDbContext(DbContextOptions options) : base(options) { }
    }
}

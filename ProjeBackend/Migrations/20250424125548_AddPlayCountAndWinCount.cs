using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ProjeBackend.Migrations
{
    /// <inheritdoc />
    public partial class AddPlayCountAndWinCount : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "PlayCount",
                table: "Games",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "WinCount",
                table: "Card",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PlayCount",
                table: "Games");

            migrationBuilder.DropColumn(
                name: "WinCount",
                table: "Card");
        }
    }
}

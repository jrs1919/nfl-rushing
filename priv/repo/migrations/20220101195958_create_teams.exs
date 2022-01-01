defmodule NFLRushing.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :abbreviation, :string, null: false, size: 3
      add :city, :string, null: false
      add :mascot, :string, null: false

      timestamps()
    end

    create unique_index(:teams, [:abbreviation])
  end
end

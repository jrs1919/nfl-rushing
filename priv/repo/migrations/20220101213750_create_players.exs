defmodule NFLRushing.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string, null: false
      add :position, :string, null: false, size: 2
      add :team_id, references(:teams)

      timestamps()
    end

    create index(:players, ["name text_pattern_ops"])
    create index(:players, [:team_id])
  end
end

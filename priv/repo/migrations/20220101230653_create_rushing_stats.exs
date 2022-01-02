defmodule NFLRushing.Repo.Migrations.CreateRushingStats do
  use Ecto.Migration

  def change do
    create table(:rushing_stats) do
      add :attempts, :integer, null: false, default: 0
      add :attempts_per_game_average, :float, null: false, default: 0.0
      add :average_yards_per_attempt, :float, null: false, default: 0.0
      add :first_downs, :integer, null: false, default: 0
      add :first_down_percentage, :float, null: false, default: 0
      add :forty_plus_yard_rushes, :integer, null: false, default: 0
      add :fumbles, :integer, null: false, default: 0
      add :is_longest_rush_touchdown, :boolean, null: false, default: false
      add :longest_rush, :integer, null: false, default: 0
      add :player_id, references(:players, on_delete: :delete_all), null: false
      add :total_yards, :integer, null: false, default: 0
      add :touchdowns, :integer, null: false, default: 0
      add :twenty_plus_yard_rushes, :integer, null: false, default: 0
      add :yards_per_game, :float, null: false, default: 0.0

      timestamps()
    end

    create unique_index(:rushing_stats, [:player_id])
  end
end

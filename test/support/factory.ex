defmodule NFLRushing.Factory do
  use ExMachina.Ecto, repo: NFLRushing.Repo
  alias NFLRushing.Schemas.{Player, RushingStats, Team}

  def rushing_stats_factory do
    %RushingStats{
      attempts: 10,
      attempts_per_game_average: 2.1,
      average_yards_per_attempt: 8.3,
      first_downs: 3,
      first_down_percentage: 23.1,
      forty_plus_yard_rushes: 1,
      fumbles: 1,
      is_longest_rush_touchdown: false,
      longest_rush: 21,
      player: build(:player),
      total_yards: 80,
      touchdowns: 1,
      twenty_plus_yard_rushes: 2,
      yards_per_game: 12.3
    }
  end

  def player_factory do
    %Player{
      name: "Patrick Mahomes",
      position: "QB",
      team: build(:team)
    }
  end

  def team_factory do
    abbreviation = for _ <- 1..3, into: "", do: <<Enum.random(?a..?z)>>

    %Team{
      abbreviation: abbreviation,
      city: "Kansas City",
      mascot: "Chiefs"
    }
  end
end

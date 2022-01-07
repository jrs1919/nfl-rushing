defmodule NFLRushing.Factory do
  use ExMachina.Ecto, repo: NFLRushing.Repo
  alias NFLRushing.Schemas.{Player, RushingStats, Team}

  def rushing_stats_factory do
    %RushingStats{
      attempts: random_integer(),
      attempts_per_game_average: random_float(),
      average_yards_per_attempt: random_float(),
      first_downs: random_integer(),
      first_down_percentage: random_float(),
      forty_plus_yard_rushes: random_integer(),
      fumbles: random_integer(),
      is_longest_rush_touchdown: Enum.random([true, false]),
      longest_rush: random_integer(),
      player: build(:player),
      total_yards: random_integer(),
      touchdowns: random_integer(),
      twenty_plus_yard_rushes: random_integer(),
      yards_per_game: random_float()
    }
  end

  defp random_integer, do: :rand.uniform(256)

  defp random_float, do: :rand.uniform() * 10 |> Float.round(2)

  def player_factory do
    %Player{
      name: "John Doe",
      position: Enum.random(~w(QB RB WR TE)),
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

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NFLRushing.Repo.insert!(%NFLRushing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import NFLRushing.NumberUtils
alias NFLRushing.Stats

teams = [
  %{abbreviation: "ARI", city: "Arizona", mascot: "Cardinals"},
  %{abbreviation: "ATL", city: "Atlanta", mascot: "Falcons"},
  %{abbreviation: "BAL", city: "Baltimore", mascot: "Ravens"},
  %{abbreviation: "BUF", city: "Buffalo", mascot: "Bills"},
  %{abbreviation: "CAR", city: "Carolina", mascot: "Panthers"},
  %{abbreviation: "CHI", city: "Chicago", mascot: "Bears"},
  %{abbreviation: "CIN", city: "Cincinnati", mascot: "Bengals"},
  %{abbreviation: "CLE", city: "Cleveland", mascot: "Browns"},
  %{abbreviation: "DAL", city: "Dallas", mascot: "Cowboys"},
  %{abbreviation: "DEN", city: "Denver", mascot: "Broncos"},
  %{abbreviation: "DET", city: "Detroit", mascot: "Lions"},
  %{abbreviation: "GB", city: "Green Bay", mascot: "Packers"},
  %{abbreviation: "HOU", city: "Houston", mascot: "Texans"},
  %{abbreviation: "IND", city: "Indianapolis", mascot: "Colts"},
  %{abbreviation: "JAX", city: "Jacksonville", mascot: "Jaguars"},
  %{abbreviation: "KC", city: "Kansas City", mascot: "Chiefs"},
  %{abbreviation: "LA", city: "Los Angeles", mascot: "Rams"},
  %{abbreviation: "MIA", city: "Miami", mascot: "Dolphins"},
  %{abbreviation: "MIN", city: "Minnesota", mascot: "Vikings"},
  %{abbreviation: "NE", city: "New England", mascot: "Patriots"},
  %{abbreviation: "NO", city: "New Orleans", mascot: "Saints"},
  %{abbreviation: "NYG", city: "New York", mascot: "Giants"},
  %{abbreviation: "NYJ", city: "New York", mascot: "Jets"},
  %{abbreviation: "OAK", city: "Oakland", mascot: "Raiders"},
  %{abbreviation: "PHI", city: "Philadelphia", mascot: "Eagles"},
  %{abbreviation: "PIT", city: "Pittsburgh", mascot: "Steelers"},
  %{abbreviation: "SD", city: "San Diego", mascot: "Chargers"},
  %{abbreviation: "SF", city: "San Francisco", mascot: "49ers"},
  %{abbreviation: "SEA", city: "Seattle", mascot: "Seahawks"},
  %{abbreviation: "TEN", city: "Tennessee", mascot: "Titans"},
  %{abbreviation: "TB", city: "Tampa Bay", mascot: "Buccaneers"},
  %{abbreviation: "WAS", city: "Washington", mascot: "Football Team"}
]

teams =
  Enum.into(teams, %{}, fn team ->
    {:ok, team} = Stats.create_team(team)
    {team.abbreviation, team}
  end)

Path.join(__DIR__, "rushing.json")
|> File.read!()
|> Jason.decode!()
|> Enum.each(fn item ->
  team = Map.fetch!(teams, item["Team"])

  {:ok, player} =
    Stats.create_player(%{
      name: Map.fetch!(item, "Player"),
      position: Map.fetch!(item, "Pos"),
      team_id: team.id
    })

  {longest_rush, is_longest_rush_touchdown} = item |> Map.fetch!("Lng") |> parse_compound_stat()

  {:ok, _} =
    Stats.create_rushing_stats(%{
      attempts: item |> Map.fetch!("Att") |> parse_integer(),
      attempts_per_game_average: item |> Map.fetch!("Att/G") |> parse_float(),
      average_yards_per_attempt: item |> Map.fetch!("Avg") |> parse_float(),
      first_downs: item |> Map.fetch!("1st") |> parse_integer(),
      first_down_percentage: item |> Map.fetch!("1st%") |> parse_float(),
      forty_plus_yard_rushes: item |> Map.fetch!("40+") |> parse_integer(),
      fumbles: item |> Map.fetch!("FUM") |> parse_integer(),
      is_longest_rush_touchdown: is_longest_rush_touchdown,
      longest_rush: longest_rush,
      player_id: player.id,
      total_yards: item |> Map.fetch!("Yds") |> parse_integer(),
      touchdowns: item |> Map.fetch!("TD") |> parse_integer(),
      twenty_plus_yard_rushes: item |> Map.fetch!("20+") |> parse_integer(),
      yards_per_game: item |> Map.fetch!("Yds/G") |> parse_float()
    })
end)

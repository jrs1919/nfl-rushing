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

Enum.each(teams, fn team ->
  {:ok, _} = Stats.create_or_update_team(team)
end)

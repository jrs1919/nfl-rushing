defmodule NFLRushingWeb.CSVExportController do
  use NFLRushingWeb, :controller
  alias NFLRushing.Stats
  alias NFLRushing.Schemas.Team
  alias NimbleCSV.RFC4180, as: CSV

  @headers [
    "Name",
    "Team",
    "Position",
    "Total Yds",
    "Attempts",
    "Attempts/G",
    "TD",
    "Yds/G",
    "Avg Yds/Attempt",
    "1st Downs",
    "1st Down %",
    "20+ Yd Rushes",
    "40+ Yd Rushes",
    "Fumbles",
    "Longest Rush",
    "Longest Rush TD"
  ]

  def new(conn, %{"query" => query}) do
    players =
      query
      |> parse_query()
      |> Stats.list_players_with_stats()
      |> Enum.map(
        &[
          &1.name,
          Team.name(&1.team),
          &1.position,
          &1.rushing_stats.total_yards,
          &1.rushing_stats.attempts,
          &1.rushing_stats.attempts_per_game_average,
          &1.rushing_stats.touchdowns,
          &1.rushing_stats.yards_per_game,
          &1.rushing_stats.average_yards_per_attempt,
          &1.rushing_stats.first_downs,
          &1.rushing_stats.first_down_percentage,
          &1.rushing_stats.twenty_plus_yard_rushes,
          &1.rushing_stats.forty_plus_yard_rushes,
          &1.rushing_stats.fumbles,
          &1.rushing_stats.longest_rush,
          &1.rushing_stats.is_longest_rush_touchdown
        ]
      )

    csv_content = CSV.dump_to_iodata([@headers | players])

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"rushing_stats.csv\"")
    |> send_resp(200, csv_content)
  end

  defp parse_query(query) do
    query = Jason.decode!(query, keys: :atoms)

    order =
      query.order
      |> Enum.map(&Map.to_list/1)
      |> List.flatten()
      |> Enum.map(fn {key, value} -> {key, String.to_existing_atom(value)} end)

    query = %{query | order: order}
    {_, query} = pop_in(query, [:filter, :limit])
    {_, query} = pop_in(query, [:filter, :offset])

    query
  end
end

defmodule NFLRushingWeb.CSVExportControllerTest do
  use NFLRushingWeb.ConnCase
  alias NimbleCSV.RFC4180, as: CSV
  alias NFLRushing.Schemas.Team

  describe "new" do
    test "exports a CSV of player stats", %{conn: conn} do
      stats = insert_list(10, :rushing_stats) |> Enum.sort_by(& &1.player.id)
      query = %{order: [%{player_id: :asc}]}
      conn = post(conn, Routes.csv_export_path(conn, :new), query: Jason.encode!(query))
      results = CSV.parse_string(conn.resp_body)

      assert conn.status == 200
      assert get_resp_header(conn, "content-type") == ["text/csv; charset=utf-8"]
      assert length(results) == length(stats)

      for {stat, index} <- Enum.with_index(stats) do
        result = Enum.at(results, index)

        assert result == [
                 stat.player.name,
                 Team.name(stat.player.team),
                 to_string(stat.player.position),
                 to_string(stat.total_yards),
                 to_string(stat.attempts),
                 to_string(stat.attempts_per_game_average),
                 to_string(stat.touchdowns),
                 to_string(stat.yards_per_game),
                 to_string(stat.average_yards_per_attempt),
                 to_string(stat.first_downs),
                 to_string(stat.first_down_percentage),
                 to_string(stat.twenty_plus_yard_rushes),
                 to_string(stat.forty_plus_yard_rushes),
                 to_string(stat.fumbles),
                 to_string(stat.longest_rush),
                 to_string(stat.is_longest_rush_touchdown)
               ]
      end
    end

    test "ignores the limit and offset fields in the query", %{conn: conn} do
      stats = insert_list(10, :rushing_stats)
      query = %{order: [%{player_id: :asc}], filter: %{limit: 2, offset: 2}}
      conn = post(conn, Routes.csv_export_path(conn, :new), query: Jason.encode!(query))
      results = CSV.parse_string(conn.resp_body)

      assert conn.status == 200
      assert length(results) == length(stats)
    end
  end
end

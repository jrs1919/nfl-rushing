defmodule NFLRushingWeb.StatsLiveTest do
  use NFLRushingWeb.ConnCase
  import Phoenix.LiveViewTest
  alias NFLRushingWeb.StatsLive

  test "lists players and their stats", %{conn: conn} do
    stats = insert(:rushing_stats)
    {:ok, _live, html} = live(conn, Routes.live_path(conn, StatsLive))

    assert html =~ stats.player.name
    assert html =~ "#{stats.player.team.city} #{stats.player.team.mascot}"
    assert html =~ stats.player.position
    assert html =~ to_string(stats.total_yards)
    assert html =~ to_string(stats.attempts)
    assert html =~ to_string(stats.attempts_per_game_average)
    assert html =~ to_string(stats.touchdowns)
    assert html =~ to_string(stats.yards_per_game)
    assert html =~ to_string(stats.average_yards_per_attempt)
    assert html =~ to_string(stats.first_downs)
    assert html =~ to_string(stats.first_down_percentage)
    assert html =~ to_string(stats.twenty_plus_yard_rushes)
    assert html =~ to_string(stats.forty_plus_yard_rushes)
    assert html =~ to_string(stats.fumbles)
    assert html =~ to_string(stats.longest_rush)
  end
end

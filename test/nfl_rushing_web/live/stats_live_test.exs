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
    assert html =~ stats.total_yards
    assert html =~ stats.attempts
    assert html =~ stats.attempts_per_game_average
    assert html =~ stats.touchdowns
    assert html =~ stats.yards_per_game
    assert html =~ stats.average_yards_per_attempt
    assert html =~ stats.first_downs
    assert html =~ stats.first_down_percentage
    assert html =~ stats.twenty_plus_yard_rushes
    assert html =~ stats.forty_plus_yard_rushes
    assert html =~ stats.fumbles
    assert html =~ stats.longest_rush
  end
end

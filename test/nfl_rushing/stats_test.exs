defmodule NFLRushing.StatsTest do
  use NFLRushing.DataCase, async: true
  alias NFLRushing.Stats

  describe "create_player/1" do
    test "creates a new player with the given data" do
      attrs = params_with_assocs(:player, team: build(:team))

      assert {:ok, player} = Stats.create_player(attrs)
      assert player.name == attrs.name
      assert player.position == attrs.position
      assert player.team_id == attrs.team_id
    end

    test "returns an error if the player cannot be created" do
      attrs = params_with_assocs(:player, name: nil)

      assert {:error, _} = Stats.create_player(attrs)
    end
  end

  describe "create_team/1" do
    test "creates a new team with the given data" do
      attrs = params_for(:team)

      assert {:ok, team} = Stats.create_team(attrs)
      assert team.abbreviation == attrs.abbreviation
      assert team.city == attrs.city
      assert team.mascot == attrs.mascot
    end

    test "returns an error if the team cannot be created" do
      attrs = params_for(:team, city: nil)

      assert {:error, _} = Stats.create_team(attrs)
    end
  end

  describe "get_team_by_abbreviation/1" do
    test "retrieves the team with the given abbreviation" do
      team = insert(:team)
      fetched_team = Stats.get_team_by_abbreviation!(team.abbreviation)

      assert team == fetched_team
    end

    test "returns nil if the team is not found" do
      assert nil == Stats.get_team_by_abbreviation!("SEA")
    end
  end

  describe "list_players_with_stats/1" do
    test "returns a set of players" do
      players = insert_list(10, :rushing_stats) |> Enum.map(& &1.player)
      results = Stats.list_players_with_stats()
      player_ids = Enum.map(results, & &1.id)

      assert length(results) == 10
      for p <- players, do: assert(p.id in player_ids)
    end

    test "limits the result set size" do
      insert_list(20, :rushing_stats)
      results = Stats.list_players_with_stats(%{filter: [limit: 10]})

      assert length(results) == 10
    end

    test "offsets the result set" do
      [p1, p2, p3] = insert_list(3, :rushing_stats) |> Enum.map(& &1.player)

      assert [result] = Stats.list_players_with_stats(%{filter: [limit: 1, offset: 0]})
      assert p1.id == result.id

      assert [result] = Stats.list_players_with_stats(%{filter: [limit: 1, offset: 1]})
      assert p2.id == result.id

      assert [result] = Stats.list_players_with_stats(%{filter: [limit: 1, offset: 2]})
      assert p3.id == result.id

      assert [] = Stats.list_players_with_stats(%{filter: [offset: 3]})
    end

    test "filters by player name" do
      p1 = insert(:player, name: "Joe Montana")
      p2 = insert(:player, name: "Joe Namath")
      p3 = insert(:player, name: "Len Dawson")
      insert(:rushing_stats, player: p1)
      insert(:rushing_stats, player: p2)
      insert(:rushing_stats, player: p3)
      results = Stats.list_players_with_stats(%{filter: [player_name: "Joe"]})
      names = Enum.map(results, & &1.name)

      assert length(results) == 2
      assert p1.name in names
      assert p2.name in names
    end

    test "sorts the results by longest rush" do
      [p1, p2, p3] = insert_list(3, :player)
      insert(:rushing_stats, player: p1, longest_rush: 23)
      insert(:rushing_stats, player: p2, longest_rush: 55)
      insert(:rushing_stats, player: p3, longest_rush: 31)

      [result1, result2, result3] = Stats.list_players_with_stats(%{order: [longest_rush: :asc]})

      assert result1.id == p1.id
      assert result2.id == p3.id
      assert result3.id == p2.id

      [result1, result2, result3] = Stats.list_players_with_stats(%{order: [longest_rush: :desc]})

      assert result1.id == p2.id
      assert result2.id == p3.id
      assert result3.id == p1.id
    end

    test "sorts the results by total rushing yards" do
      [p1, p2, p3] = insert_list(3, :player)
      insert(:rushing_stats, player: p1, total_yards: 201)
      insert(:rushing_stats, player: p2, total_yards: 542)
      insert(:rushing_stats, player: p3, total_yards: 331)

      [result1, result2, result3] = Stats.list_players_with_stats(%{order: [total_yards: :asc]})

      assert result1.id == p1.id
      assert result2.id == p3.id
      assert result3.id == p2.id

      [result1, result2, result3] = Stats.list_players_with_stats(%{order: [total_yards: :desc]})

      assert result1.id == p2.id
      assert result2.id == p3.id
      assert result3.id == p1.id
    end

    test "sorts the results by touchdowns" do
      [p1, p2, p3] = insert_list(3, :player)
      insert(:rushing_stats, player: p1, touchdowns: 5)
      insert(:rushing_stats, player: p2, touchdowns: 10)
      insert(:rushing_stats, player: p3, touchdowns: 7)

      [result1, result2, result3] = Stats.list_players_with_stats(%{order: [touchdowns: :asc]})
      assert result1.id == p1.id
      assert result2.id == p3.id
      assert result3.id == p2.id

      [result1, result2, result3] = Stats.list_players_with_stats(%{order: [touchdowns: :desc]})

      assert result1.id == p2.id
      assert result2.id == p3.id
      assert result3.id == p1.id
    end

    test "sorts the results by player id" do
      player_ids = insert_list(3, :rushing_stats) |> Enum.map(& &1.player.id) |> Enum.sort()

      result_ids =
        Stats.list_players_with_stats(%{order: [player_id: :asc]})
        |> Enum.map(& &1.id)

      assert player_ids == result_ids

      result_ids =
        Stats.list_players_with_stats(%{order: [player_id: :desc]})
        |> Enum.map(& &1.id)

      assert Enum.reverse(player_ids) == result_ids
    end
  end

  describe "number_of_players_with_stats/1" do
    test "returns the total number of players with stats" do
      insert_list(20, :rushing_stats)

      assert Stats.number_of_players_with_stats() == 20
    end

    test "returns the total number of players with stats based on the given query filter" do
      p1 = insert(:player, name: "Joe Montana")
      p2 = insert(:player, name: "Joe Namath")
      p3 = insert(:player, name: "Len Dawson")
      insert(:rushing_stats, player: p1)
      insert(:rushing_stats, player: p2)
      insert(:rushing_stats, player: p3)

      assert Stats.number_of_players_with_stats(%{filter: [player_name: "Joe"]}) == 2
    end
  end
end

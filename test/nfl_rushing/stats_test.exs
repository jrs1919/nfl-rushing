defmodule NFLRushing.StatsTest do
  use NFLRushing.DataCase, async: true
  alias NFLRushing.Stats

  describe "create_player/1" do
    test "creates a new player with the given data" do
      attrs = params_with_assocs(:player)

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
end

defmodule NFLRushing.StatsTest do
  use NFLRushing.DataCase, async: true
  alias NFLRushing.Stats

  @team_attrs %{
    abbreviation: "KC",
    city: "Kansas City",
    mascot: "Chiefs"
  }

  describe "create_player/1" do
    setup do
      {:ok, team} = Stats.create_team(@team_attrs)

      player_attrs = %{
        name: "Patrick Mahomes",
        position: "QB",
        team_id: team.id
      }

      {:ok, attrs: player_attrs}
    end

    test "creates a new player with the given data", %{attrs: attrs} do
      assert {:ok, player} = Stats.create_player(attrs)
      assert player.name == attrs.name
      assert player.position == attrs.position
      assert player.team_id == attrs.team_id
    end

    test "returns an error if the player cannot be created", %{attrs: attrs} do
      attrs = %{attrs | name: nil}

      assert {:error, _} = Stats.create_player(attrs)
    end
  end

  describe "create_team/1" do
    test "creates a new team with the given data" do
      assert {:ok, team} = Stats.create_team(@team_attrs)
      assert team.abbreviation == @team_attrs.abbreviation
      assert team.city == @team_attrs.city
      assert team.mascot == @team_attrs.mascot
    end

    test "returns an error if the team cannot be created" do
      attrs = %{@team_attrs | city: nil}

      assert {:error, _} = Stats.create_team(attrs)
    end
  end

  describe "get_team_by_abbreviation/1" do
    test "retrieves the team with the given abbreviation" do
      {:ok, team} = Stats.create_team(@team_attrs)
      fetched_team = Stats.get_team_by_abbreviation!(team.abbreviation)

      assert team == fetched_team
    end

    test "returns nil if the team is not found" do
      assert nil == Stats.get_team_by_abbreviation!("SEA")
    end
  end
end

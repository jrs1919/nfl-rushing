defmodule NFLRushing.StatsTest do
  use NFLRushing.DataCase, async: true
  alias NFLRushing.Stats

  describe "create_or_update_team/1" do
    @team_attrs %{
      abbreviation: "KC",
      city: "Kansas City",
      mascot: "Chiefs"
    }

    test "creates a new team with the given data" do
      assert {:ok, team} = Stats.create_or_update_team(@team_attrs)
      assert team.abbreviation == @team_attrs.abbreviation
      assert team.city == @team_attrs.city
      assert team.mascot == @team_attrs.mascot
    end

    test "updates an existing team with the given data" do
      {:ok, team} = Stats.create_or_update_team(@team_attrs)
      attrs = %{@team_attrs | city: "Seattle", mascot: "Seahawks"}

      assert {:ok, updated_team} = Stats.create_or_update_team(attrs)
      assert updated_team.id == team.id
      assert updated_team.abbreviation == team.abbreviation
      assert updated_team.city == attrs.city
      assert updated_team.mascot == attrs.mascot
    end

    test "returns an error if the team cannot be created" do
      attrs = %{@team_attrs | city: nil}

      assert {:error, _} = Stats.create_or_update_team(attrs)
    end
  end
end

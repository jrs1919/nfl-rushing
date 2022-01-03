defmodule NFLRushing.Schemas.RushingStatsTest do
  use NFLRushing.DataCase, async: true
  alias NFLRushing.Schemas.RushingStats

  describe "changeset/2" do
    test "with valid attributes" do
      attrs = params_with_assocs(:rushing_stats)
      changeset = RushingStats.changeset(%RushingStats{}, attrs)

      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = RushingStats.changeset(%RushingStats{}, %{})

      refute changeset.valid?
      assert %{attempts: ["can't be blank"]} = errors_on(changeset)
      assert %{attempts_per_game_average: ["can't be blank"]} = errors_on(changeset)
      assert %{average_yards_per_attempt: ["can't be blank"]} = errors_on(changeset)
      assert %{first_downs: ["can't be blank"]} = errors_on(changeset)
      assert %{first_down_percentage: ["can't be blank"]} = errors_on(changeset)
      assert %{forty_plus_yard_rushes: ["can't be blank"]} = errors_on(changeset)
      assert %{fumbles: ["can't be blank"]} = errors_on(changeset)
      assert %{is_longest_rush_touchdown: ["can't be blank"]} = errors_on(changeset)
      assert %{longest_rush: ["can't be blank"]} = errors_on(changeset)
      assert %{player_id: ["can't be blank"]} = errors_on(changeset)
      assert %{total_yards: ["can't be blank"]} = errors_on(changeset)
      assert %{touchdowns: ["can't be blank"]} = errors_on(changeset)
      assert %{twenty_plus_yard_rushes: ["can't be blank"]} = errors_on(changeset)
      assert %{yards_per_game: ["can't be blank"]} = errors_on(changeset)
    end

    test "with an invalid player" do
      attrs = params_for(:rushing_stats, player_id: -1)

      assert {:error, changeset} =
               %RushingStats{}
               |> RushingStats.changeset(attrs)
               |> Repo.insert()

      assert %{player_id: ["does not exist"]} = errors_on(changeset)
    end

    test "creating duplicate stats for a player" do
      attrs = params_with_assocs(:rushing_stats)

      assert {:ok, _} =
               %RushingStats{}
               |> RushingStats.changeset(attrs)
               |> Repo.insert()

      assert {:error, changeset} =
               %RushingStats{}
               |> RushingStats.changeset(attrs)
               |> Repo.insert()

      assert %{player_id: ["already exist for this player"]} = errors_on(changeset)
    end
  end
end

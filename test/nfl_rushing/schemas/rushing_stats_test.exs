defmodule NFLRushing.Schemas.RushingStatsTest do
  use NFLRushing.DataCase, async: true
  alias NFLRushing.Schemas.{Player, RushingStats}

  describe "changeset/2" do
    setup do
      player_attrs = %{
        name: "Patrick Mahomes",
        position: "QB"
      }

      player =
        %Player{}
        |> Player.changeset(player_attrs)
        |> Repo.insert!()

      rushing_stats_attrs = %{
        attempts: 10,
        attempts_per_game_average: 2.1,
        average_yards_per_attempt: 8.3,
        first_downs: 3,
        first_down_percentage: 23.1,
        forty_plus_yard_rushes: 1,
        fumbles: 1,
        is_longest_rush_touchdown: false,
        longest_rush: 21,
        player_id: player.id,
        total_yards: 80,
        touchdowns: 1,
        twenty_plus_yard_rushes: 2,
        yards_per_game: 12.3
      }

      {:ok, attrs: rushing_stats_attrs}
    end

    test "with valid attributes", %{attrs: attrs} do
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

    test "with an invalid player", %{attrs: attrs} do
      attrs = %{attrs | player_id: 0}

      assert {:error, changeset} =
               %RushingStats{}
               |> RushingStats.changeset(attrs)
               |> Repo.insert()

      assert %{player_id: ["does not exist"]} = errors_on(changeset)
    end

    test "creating duplicate stats for a player", %{attrs: attrs} do
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

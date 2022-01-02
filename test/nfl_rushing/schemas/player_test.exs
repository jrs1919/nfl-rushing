defmodule NFLRushing.Schemas.PlayerTest do
  use NFLRushing.DataCase, async: true
  alias NFLRushing.Schemas.{Player, Team}

  describe "changeset/2" do
    setup do
      team_attrs = %{
        abbreviation: "KC",
        city: "Kansas City",
        mascot: "Chiefs"
      }

      team =
        %Team{}
        |> Team.changeset(team_attrs)
        |> Repo.insert!()

      player_attrs = %{
        name: "Patrick Mahomes",
        position: "QB",
        team_id: team.id
      }

      {:ok, attrs: player_attrs}
    end

    test "with valid attributes", %{attrs: attrs} do
      changeset = Player.changeset(%Player{}, attrs)

      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Player.changeset(%Player{}, %{})

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
      assert %{position: ["can't be blank"]} = errors_on(changeset)
    end

    test "with an invalid position", %{attrs: attrs} do
      attrs = %{attrs | position: "WR2"}
      changeset = Player.changeset(%Player{}, attrs)

      refute changeset.valid?
      assert %{position: ["should be at most 2 character(s)"]} = errors_on(changeset)
    end

    test "with an invalid team", %{attrs: attrs} do
      attrs = %{attrs | team_id: -1}

      assert {:error, changeset} =
               %Player{}
               |> Player.changeset(attrs)
               |> Repo.insert()

      assert %{team_id: ["does not exist"]} = errors_on(changeset)
    end
  end
end

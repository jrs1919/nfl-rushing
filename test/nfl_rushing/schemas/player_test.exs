defmodule NFLRushing.Schemas.PlayerTest do
  use NFLRushing.DataCase, async: true
  alias NFLRushing.Schemas.Player

  describe "changeset/2" do
    test "with valid attributes" do
      attrs = params_with_assocs(:player)
      changeset = Player.changeset(%Player{}, attrs)

      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Player.changeset(%Player{}, %{})

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
      assert %{position: ["can't be blank"]} = errors_on(changeset)
    end

    test "with an invalid position" do
      attrs = params_with_assocs(:player, position: "WR2")
      changeset = Player.changeset(%Player{}, attrs)

      refute changeset.valid?
      assert %{position: ["should be at most 2 character(s)"]} = errors_on(changeset)
    end

    test "with an invalid team" do
      attrs = params_for(:player, team_id: -1)

      assert {:error, changeset} = %Player{} |> Player.changeset(attrs) |> Repo.insert()
      assert %{team_id: ["does not exist"]} = errors_on(changeset)
    end
  end
end

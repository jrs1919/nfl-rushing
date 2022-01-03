defmodule NFLRushing.Schemas.TeamTest do
  use NFLRushing.DataCase, async: true
  alias NFLRushing.Schemas.Team

  describe "changeset/2" do
    test "with valid attributes" do
      attrs = params_for(:team)
      changeset = Team.changeset(%Team{}, attrs)

      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Team.changeset(%Team{}, %{})

      refute changeset.valid?
      assert %{abbreviation: ["can't be blank"]} = errors_on(changeset)
      assert %{city: ["can't be blank"]} = errors_on(changeset)
      assert %{mascot: ["can't be blank"]} = errors_on(changeset)
    end

    test "with an invalid abbreviation" do
      attrs = params_for(:team, abbreviation: "NYSC")
      changeset = Team.changeset(%Team{}, attrs)

      refute changeset.valid?
      assert %{abbreviation: ["should be at most 3 character(s)"]} = errors_on(changeset)
    end

    test "with a duplicate abbreviation" do
      team = insert(:team)
      attrs = %{abbreviation: team.abbreviation, city: "Seattle", mascot: "Seahawks"}

      assert {:error, changeset} = %Team{} |> Team.changeset(attrs) |> Repo.insert()
      assert %{abbreviation: ["has already been taken"]} = errors_on(changeset)
    end
  end
end

defmodule NFLRushing.Schemas.TeamTest do
  use NFLRushing.DataCase, async: true
  alias NFLRushing.Schemas.Team

  describe "changeset/2" do
    @valid_attrs %{
      abbreviation: "KC",
      city: "Kansas City",
      mascot: "Chiefs"
    }

    test "with valid attributes" do
      changeset = Team.changeset(%Team{}, @valid_attrs)

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
      attrs = %{@valid_attrs | abbreviation: "NYSC"}
      changeset = Team.changeset(%Team{}, attrs)

      refute changeset.valid?
      assert %{abbreviation: ["should be at most 3 character(s)"]} = errors_on(changeset)
    end

    test "with a duplicate abbreviation" do
      # Create a new team in the database
      {:ok, team} =
        %Team{}
        |> Team.changeset(@valid_attrs)
        |> Repo.insert()

      # Attempt to create a new team with the same abbreviation
      attrs = %{abbreviation: team.abbreviation, city: "Seattle", mascot: "Seahawks"}

      assert {:error, changeset} =
               %Team{}
               |> Team.changeset(attrs)
               |> Repo.insert()

      assert %{abbreviation: ["has already been taken"]} = errors_on(changeset)
    end
  end
end

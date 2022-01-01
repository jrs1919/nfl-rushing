defmodule NFLRushing.Schemas.Team do
  @moduledoc """
  This module defines an Ecto schema that represents an individual NFL team.

  Teams are associated with a set of players.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias NFLRushing.Schemas.Player

  schema "teams" do
    field :abbreviation, :string
    field :city, :string
    field :mascot, :string

    has_many :players, Player

    timestamps()
  end

  @type t :: %__MODULE__{
          abbreviation: String.t() | nil,
          city: String.t() | nil,
          mascot: String.t() | nil
        }

  @doc """
  Builds a changeset using the given `team` struct and `attrs` data.
  """
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:abbreviation, :city, :mascot])
    |> validate_required([:abbreviation, :city, :mascot])
    |> validate_length(:abbreviation, max: 3)
    |> unique_constraint(:abbreviation)
  end
end

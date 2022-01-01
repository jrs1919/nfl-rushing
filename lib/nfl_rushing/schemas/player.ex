defmodule NFLRushing.Schemas.Player do
  @moduledoc """
  This module defines an Ecto schema that represents a player.

  Players are associated with a team and a set of rushing statistics.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias NFLRushing.Schemas.Team

  schema "players" do
    field :name, :string
    field :position, :string

    belongs_to :team, Team

    timestamps()
  end

  @type t :: %__MODULE__{
          name: String.t() | nil,
          position: String.t() | nil,
          team_id: integer() | nil
        }

  @doc """
  Builds a changeset using the given `player` struct and `attrs` data.
  """
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :position, :team_id])
    |> validate_required([:name, :position])
    |> validate_length(:position, max: 2)
    |> foreign_key_constraint(:team_id)
  end
end

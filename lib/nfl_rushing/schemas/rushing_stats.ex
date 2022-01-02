defmodule NFLRushing.Schemas.RushingStats do
  @moduledoc """
  This module defines an Ecto schema that respresents the rushing statistics for
  a player.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias NFLRushing.Schemas.Player

  schema "rushing_stats" do
    field :attempts, :integer
    field :attempts_per_game_average, :float
    field :average_yards_per_attempt, :float
    field :first_downs, :integer
    field :first_down_percentage, :float
    field :forty_plus_yard_rushes, :integer
    field :fumbles, :integer
    field :is_longest_rush_touchdown, :boolean
    field :longest_rush, :integer
    field :total_yards, :integer
    field :touchdowns, :integer
    field :twenty_plus_yard_rushes, :integer
    field :yards_per_game, :float

    belongs_to :player, Player

    timestamps()
  end

  @type t :: %__MODULE__{
          attempts: integer() | nil,
          attempts_per_game_average: float() | nil,
          average_yards_per_attempt: float() | nil,
          first_downs: integer() | nil,
          first_down_percentage: float() | nil,
          forty_plus_yard_rushes: integer() | nil,
          fumbles: integer() | nil,
          is_longest_rush_touchdown: boolean() | nil,
          longest_rush: integer() | nil,
          player_id: integer() | nil,
          total_yards: integer() | nil,
          touchdowns: integer() | nil,
          twenty_plus_yard_rushes: integer() | nil,
          yards_per_game: float() | nil
        }

  @doc """
  Builds a changeset using the given `rushing_stats` and `attrs` data.
  """
  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(rushing_stats, attrs) do
    required_fields = [
      :attempts,
      :attempts_per_game_average,
      :average_yards_per_attempt,
      :first_downs,
      :first_down_percentage,
      :forty_plus_yard_rushes,
      :fumbles,
      :is_longest_rush_touchdown,
      :longest_rush,
      :player_id,
      :total_yards,
      :touchdowns,
      :twenty_plus_yard_rushes,
      :yards_per_game
    ]

    rushing_stats
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:player_id, message: "already exist for this player")
    |> foreign_key_constraint(:player_id)
  end
end

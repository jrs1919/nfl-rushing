defmodule NFLRushing.Stats do
  @moduledoc """
  This module provides an API for working with stats based functionality for
  players and teams.
  """

  import Ecto.Query
  alias NFLRushing.Repo
  alias NFLRushing.Schemas.{Player, Team}

  @doc """
  Creates a player using the given `attrs` data.
  """
  @spec create_player(map()) :: {:ok, Player.t()} | {:error, Ecto.Changeset.t()}
  def create_player(attrs) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a team using the given `attrs` data.
  """
  @spec create_team(map()) :: {:ok, Team.t()} | {:error, Ecto.Changeset.t()}
  def create_team(attrs) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Fetches a team with the given `abbreviation`.  

  `nil` is returned if the team with `abbreviation` does not exist.
  """
  @spec get_team_by_abbreviation!(String.t()) :: Team.t() | nil
  def get_team_by_abbreviation!(abbreviation) do
    Team
    |> where([t], t.abbreviation == ^abbreviation)
    |> Repo.one()
  end
end

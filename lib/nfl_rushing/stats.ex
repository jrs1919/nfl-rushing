defmodule NFLRushing.Stats do
  @moduledoc """
  This module provides an API for working with stats based functionality for
  players and teams.
  """

  alias NFLRushing.Repo
  alias NFLRushing.Schemas.Team

  @doc """
  Creates or updates a team using the given `attrs` data.

  If a team already exists with the abbreviation in `attrs`, the existing team
  data is updated in the database with the data in `attrs`.
  """
  @spec create_or_update_team(map()) :: {:ok, Team.t()} | {:error, Ecto.Changeset.t()}
  def create_or_update_team(attrs) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert(on_conflict: {:replace_all_except, [:id]}, conflict_target: :abbreviation)
  end
end

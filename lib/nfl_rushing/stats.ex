defmodule NFLRushing.Stats do
  @moduledoc """
  This module provides an API for working with stats based functionality for
  players and teams.
  """

  import Ecto.Query
  alias NFLRushing.Repo
  alias NFLRushing.Schemas.{Player, RushingStats, Team}

  @type lpws_filter_t :: %{atom() => integer() | String.t()} | nil
  @type lpws_order_t :: [{atom(), atom()}] | nil
  @type lpws_query_params_t ::
          %{filter: lpws_filter_t(), order: lpws_order_t()}
          | %{filter: lpws_filter_t()}
          | %{order: lpws_order_t()}

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
  Creates a set of rushing stats using the given `attrs` data.
  """
  @spec create_rushing_stats(map()) :: {:ok, RushingStats.t()} | {:error, Ecto.Changeset.t()}
  def create_rushing_stats(attrs) do
    %RushingStats{}
    |> RushingStats.changeset(attrs)
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

  @doc """
  Returns a set of players with their team and rushing stats data based on the
  given query params.
  """
  @spec list_players_with_stats(lpws_query_params_t() | nil) :: [Player.t()]
  def list_players_with_stats(params \\ nil) do
    params
    |> lpws_query()
    |> join(:left, [p], t in assoc(p, :team), as: :team)
    |> preload([p, rushing_stats: rs, team: t], rushing_stats: rs, team: t)
    |> Repo.all()
  end

  @doc """
  Returns the number of players with stats that exists based on the given query
  params.
  """
  @spec number_of_players_with_stats(lpws_query_params_t() | nil) :: integer()
  def number_of_players_with_stats(params \\ nil) do
    params
    |> lpws_query()
    |> Repo.aggregate(:count)
  end

  defp lpws_query(params) do
    Player
    |> join(:inner, [p], rs in assoc(p, :rushing_stats), as: :rushing_stats)
    |> lpws_filter_with(params)
    |> lpws_order_with(params)
  end

  defp lpws_filter_with(query, %{filter: filters}) do
    Enum.reduce(filters, query, fn
      {:limit, limit}, query ->
        limit(query, [p], ^limit)

      {:offset, offset}, query ->
        offset(query, [p], ^offset)

      {:player_name, player_name}, query ->
        where(query, [p], ilike(p.name, ^"#{player_name}%"))
    end)
  end

  defp lpws_filter_with(query, _), do: query

  defp lpws_order_with(query, %{order: orders}) do
    Enum.reduce(orders, query, fn
      {direction, :longest_rush}, query ->
        order_by(query, [rushing_stats: rs], {^direction, rs.longest_rush})

      {direction, :total_yards}, query ->
        order_by(query, [rushing_stats: rs], {^direction, rs.total_yards})

      {direction, :touchdowns}, query ->
        order_by(query, [rushing_stats: rs], {^direction, rs.touchdowns})

      {direction, :player_id}, query ->
        order_by(query, [p], {^direction, p.id})
    end)
  end

  defp lpws_order_with(query, _), do: query
end

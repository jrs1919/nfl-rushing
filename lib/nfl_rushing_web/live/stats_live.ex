defmodule NFLRushingWeb.StatsLive do
  @moduledoc """
  This module provides a live view for displaying player rushing stats.
  """

  use NFLRushingWeb, :live_view
  alias __MODULE__
  alias NFLRushing.Stats

  @page_size 10
  @default_stats_query %{
    order: [
      desc: :touchdowns,
      asc: :player_id
    ],
    filter: %{
      limit: @page_size,
      offset: 0
    }
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok, update_socket(socket, [], @default_stats_query, 0)}
  end

  @impl true
  def handle_event("search", params, socket) do
    params = Map.put(params, "offset", 0)
    {query, players} = get_stats(params, socket)
    total_players = get_total_players(query)

    {:noreply, update_socket(socket, players, query, total_players)}
  end

  def handle_event("load_more", params, %{assigns: %{query: query}} = socket) do
    offset = Access.get(query.filter, :offset) + Access.get(query.filter, :limit)
    params = Map.put(params, "offset", offset)
    {query, new_players} = get_stats(params, socket)

    {:noreply, update_socket(socket, socket.assigns.players ++ new_players, query)}
  end

  @impl true
  def handle_params(params, _, socket) do
    params = Map.put(params, "offset", 0)
    {query, players} = get_stats(params, socket)
    total_players = get_total_players(query)

    {:noreply, update_socket(socket, players, query, total_players)}
  end

  defp get_stats(params, socket) do
    query = build_stats_query(params, socket)
    players = Stats.list_players_with_stats(query)
    {query, players}
  end

  defp get_total_players(query) do
    {_, query} = pop_in(query, [:filter, :limit])
    {_, query} = pop_in(query, [:filter, :offset])
    Stats.number_of_players_with_stats(query)
  end

  defp update_socket(socket, players, query) do
    socket
    |> assign(:players, players)
    |> assign(:query, query)
  end

  defp update_socket(socket, players, query, total_players) do
    socket
    |> assign(:players, players)
    |> assign(:query, query)
    |> assign(:total_players, total_players)
  end

  defp build_stats_query(params, %{assigns: %{query: query}}) do
    sort_by = get_atom_value(params, "sort_by")
    direction = get_atom_value(params, "direction")

    order =
      if sort_by && direction do
        [{direction, sort_by}, asc: :player_id]
      else
        query.order
      end

    stats_query = %{
      order: order,
      filter: %{
        limit: Access.get(query.filter, :limit),
        offset: Access.get(params, "offset", query.filter.offset)
      }
    }

    cond do
      player_name = get_in(params, ["search", "query"]) ->
        put_in(stats_query, [:filter, :player_name], player_name)

      player_name = get_in(query, [:filter, :player_name]) ->
        put_in(stats_query, [:filter, :player_name], player_name)

      true ->
        stats_query
    end
  end

  defp get_atom_value(params, key) do
    value = Access.get(params, key)
    if value, do: String.to_existing_atom(value), else: nil
  end

  defp player_name(query), do: get_in(query, [:filter, :player_name])

  defp show_load_more?(players, total_players), do: length(players) + @page_size < total_players
end

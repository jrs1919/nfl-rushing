defmodule NFLRushingWeb.StatsLive do
  use NFLRushingWeb, :live_view
  alias NFLRushing.Stats

  @impl true
  def mount(params, _session, socket) do
    players =
      params
      |> build_query_params()
      |> Stats.list_players_with_stats()

    {:ok,
     socket
     |> assign(:players, players)
     |> assign(:search_query, nil)}
  end

  @impl true
  def handle_event("search", params, socket) do
    players =
      params
      |> build_query_params()
      |> Stats.list_players_with_stats()

    {:noreply,
      socket
      |> assign(:players, players)
      |> assign(:search_query, get_in(params, ["search", "query"]))}
  end

  @impl true
  def handle_params(params, _, socket) do
    players =
      params
      |> Map.put("search", %{"query" => socket.assigns.search_query})
      |> build_query_params()
      |> Stats.list_players_with_stats()

    {:noreply, assign(socket, :players, players)}
  end

  defp build_query_params(params) do
    sort_by = params |> Access.get("sort_by", "touchdowns") |> String.to_existing_atom()
    direction = params |> Access.get("direction", "desc") |> String.to_existing_atom()
    player_name = get_in(params, ["search", "query"])

    query_params = %{order: {direction, sort_by}, filter: []}

    if player_name do
      put_in(query_params, [:filter, :player_name], player_name)
    else
      query_params
    end
  end
end

defmodule NFLRushingWeb.Router do
  use NFLRushingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NFLRushingWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NFLRushingWeb do
    pipe_through :browser

    live "/", StatsLive
  end
end

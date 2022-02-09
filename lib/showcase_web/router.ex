defmodule ShowcaseWeb.Router do
  use ShowcaseWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {ShowcaseWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ShowcaseWeb do
    pipe_through(:browser)

    live("/", PageLive, :index)

    live "/sleep", SleepLive.Index, :index
    live "/password_gen", PasswordGeneratorLive, :index
    live "/rest_lookup", RESTUserLookupLive, :rest_user_lookup
    live "/graphql_lookup", GraphQLUserLookupLive, :graphql_user_lookup
    live "/chitchat", ChitChatLive, :chitchat
    live "/rover", RoverLive, :rover
    live "/shuttle", ShuttleLive, :shuttle
    post "/session/set-timezone", SessionSetTimeZoneController, :set_session_timezone
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShowcaseWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: ShowcaseWeb.Telemetry)
    end
  end
end

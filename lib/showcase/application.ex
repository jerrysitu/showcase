defmodule Showcase.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ShowcaseWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Showcase.PubSub},
      # Start the Endpoint (http/https)
      ShowcaseWeb.Endpoint,
      # Start a worker by calling: Showcase.Worker.start_link(arg)
      # {Showcase.Worker, arg}
      Showcase.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Showcase.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ShowcaseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :showcase, ShowcaseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eVbEHQ1zNK8/r/vJTBIhHzIesuiijgtPQU6lIQwZ4aujkarl0/LF20FIbbEWEPeG",
  render_errors: [view: ShowcaseWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Showcase.PubSub,
  live_view: [signing_salt: "0/QsDAPg"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :esbuild,
  version: "0.13.10",
  default: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

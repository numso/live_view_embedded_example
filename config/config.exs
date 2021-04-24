# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :live_view_embedded_example,
  ecto_repos: [LiveViewEmbeddedExample.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :live_view_embedded_example, LiveViewEmbeddedExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ogQ0iBV5bYPxmsXP9c399KQVtroK/+OqsbfRgOaKudzO1VTxU/C8IMpVaN7VpenX",
  render_errors: [view: LiveViewEmbeddedExampleWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveViewEmbeddedExample.PubSub,
  live_view: [signing_salt: "hKFGRG99"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

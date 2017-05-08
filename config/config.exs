# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phar_note,
  ecto_repos: [PharNote.Repo]

# Configures the endpoint
config :phar_note, PharNote.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wpXjjc778Ff+XpX5JBxUKNTmZ6CKNM23opj3ltX73hW/Tjfgao/5vMuQoK82svgL",
  render_errors: [view: PharNote.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PharNote.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :github_tagger_web,
  namespace: GithubTaggerWeb

# Configures the endpoint
config :github_tagger_web, GithubTaggerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QRwPk8Qe9HR2hqjxAA148/57eceuiYsboyFVsN8pVWgAwIskWR6jdVf+bPAuhNMU",
  render_errors: [view: GithubTaggerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: GithubTaggerWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :github_tagger_web, :generators,
  context_app: :github_tagger

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

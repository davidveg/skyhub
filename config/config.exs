# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :skyhub,
  ecto_repos: [Skyhub.Repo],
  url_to_call: "http://54.152.221.29/images.json"

# Configures the endpoint
config :skyhub, Skyhub.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Y663eKDatTuxT7l2rRJgs5UOYADl09KYq6y2ItnUZccM0900WGRhEijlHmd8a0qy", 
  render_errors: [view: Skyhub.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Skyhub.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

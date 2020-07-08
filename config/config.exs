# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :todo_mvc,
  ecto_repos: [TodoMvc.Repo]

# Configures the endpoint
config :todo_mvc, TodoMvcWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "l/gXxEGIBAuichiYzxYn4XB1fm3hLe2qT81IUNRHlVgVVRl/vYnH4v4EOclmObu5",
  render_errors: [view: TodoMvcWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TodoMvc.PubSub,
  live_view: [signing_salt: "8LKD9t+A"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

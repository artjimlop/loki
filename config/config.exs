# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :loki,
  ecto_repos: [Loki.Repo]

# Configures the endpoint
config :loki, LokiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sVZe+Myo9wd5oWfKV2RPOpMXQY5RiIeGRTDqyWTeQ/h4bL0GQI/dqWneszEkAhoR",
  render_errors: [view: LokiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Loki.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :loki, Loki.Accounts.Guardian,
  issuer: "Loki",
  secret_key: "ednkXywWll1d2svDEpbA39R5kfkc9l96j0+u7A8MgKM+pbwbeDsuYB8MP2WUW1hf"

# Ueberauth Config for oauth
config :ueberauth, Ueberauth,
  base_path: "/api/v1/auth",
  providers: [
    identity:
      {Ueberauth.Strategy.Identity,
       [
         callback_methods: ["POST"],
         uid_field: :username,
         nickname_field: :username,
         param_nesting: "user"
       ]}
  ]

config :phoenix, :format_encoders, "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"],
  "application/xml" => ["xml"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

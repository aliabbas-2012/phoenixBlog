# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :blog_test,
  ecto_repos: [BlogTest.Repo]

# Configures the endpoint
config :blog_test, BlogTest.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "x9EofcIKZxVs6RPCX4WhA4Zg7bEwtR1XmRvsXIcnUjyGGp2zYDTQeVzuZ+qhcLcM",
  render_errors: [view: BlogTest.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BlogTest.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"


config :blog_test, BlogTest.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  port: 587,
  username: "testservice2015@gmail.com",
  password: "abc123AB@",
  tls: :if_available, # can be `:always` or `:never`
  ssl: false, # can be `true`
  retries: 1

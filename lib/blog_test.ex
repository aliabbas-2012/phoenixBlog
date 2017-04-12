defmodule BlogTest do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(BlogTest.Repo, []),
      # Start the endpoint when the application starts
      supervisor(BlogTest.Endpoint, []),
      # Start your own worker by calling: BlogTest.Worker.start_link(arg1, arg2, arg3)
      # worker(BlogTest.Worker, [arg1, arg2, arg3]),
      # ... For chat to which user is online or not
      supervisor(BlogTest.Presence, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BlogTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BlogTest.Endpoint.config_change(changed, removed)
    :ok
  end
end

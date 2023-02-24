defmodule Moonlapse.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Moonlapse.Repo,
      # Start the Telemetry supervisor
      MoonlapseWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Moonlapse.PubSub},
      # Start the Endpoint (http/https)
      MoonlapseWeb.Endpoint,
      # Start a worker by calling: Moonlapse.Worker.start_link(arg)
      # {Moonlapse.Worker, arg}
      {Moonlapse.UserServer, [:ok]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Moonlapse.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MoonlapseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

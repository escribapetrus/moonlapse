defmodule Moonlapse.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Moonlapse.Repo,
      MoonlapseWeb.Telemetry,
      {Phoenix.PubSub, name: Moonlapse.PubSub},
      MoonlapseWeb.Endpoint,
      Moonlapse.UserPoints
    ]

    opts = [strategy: :one_for_one, name: Moonlapse.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    MoonlapseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

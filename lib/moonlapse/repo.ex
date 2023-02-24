defmodule Moonlapse.Repo do
  use Ecto.Repo,
    otp_app: :moonlapse,
    adapter: Ecto.Adapters.Postgres
end

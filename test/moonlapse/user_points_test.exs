defmodule Moonlapse.UserPointsTest do
  use Moonlapse.DataCase
  import Moonlapse.AccountsFixtures
  alias Moonlapse.UserPoints, as: Server

  setup do
    users = for x <- 101..110, do: user_fixture(%{points: x})
    # Setup necessary for running DB queries from the GenServer
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

    {:ok, users: users}
  end

  test "query_users/1 fetches n users with max points above min limit", %{users: users} do
    timestamp = DateTime.utc_now()

    max_points_users =
      users
      |> Enum.sort_by(& &1.points)
      |> Enum.reverse()
      |> Enum.take(3)

    {u, ts} = Server.query_users(3)
    assert u == max_points_users
    assert fmt_date(ts) == fmt_date(timestamp)
  end
end

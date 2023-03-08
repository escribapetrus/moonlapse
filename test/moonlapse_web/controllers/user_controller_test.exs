defmodule MoonlapseWeb.UserControllerTest do
  use MoonlapseWeb.ConnCase, async: false
  import Moonlapse.AccountsFixtures
  alias Moonlapse.Repo

  describe "index with server started" do
    setup do
      users = for x <- 101..110, do: user_fixture(%{points: x})
      # Setup necessary for running DB queries from the GenServer
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})

      {:ok, users: users}
    end

    test "returns users (id and points) and timestamp", %{conn: conn, users: users} do
      timestamp = DateTime.utc_now()

      max_points_users =
        users
        |> Enum.sort_by(& &1.points)
        |> Enum.reverse()
        |> Enum.take(2)
        |> Enum.map(&%{"id" => &1.id, "points" => &1.points})

      %{"timestamp" => ts, "users" => u} =
        conn
        |> get("/")
        |> json_response(200)

      assert u == max_points_users
      assert ts =~ fmt_date(timestamp)
    end
  end
end

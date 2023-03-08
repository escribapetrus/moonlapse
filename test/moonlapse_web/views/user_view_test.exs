defmodule MoonlapseWeb.UserViewTest do
  use MoonlapseWeb.ConnCase, async: true

  import Moonlapse.AccountsFixtures
  import Phoenix.View

  describe "index.json" do
    test "renders users (id and points) and timestamp when multiple users are returned" do
      users = for x <- 11..20, do: user_fixture(%{points: x})
      timestamp = DateTime.utc_now()

      assert render(
               MoonlapseWeb.UserView,
               "index.json",
               %{users: users, timestamp: timestamp}
             ) == %{
               timestamp: Calendar.strftime(timestamp, "%Y-%m-%d %H:%M:%S"),
               users: Enum.map(users, &%{id: &1.id, points: &1.points})
             }
    end

    test "renders empty list and timestamp when no users are returned" do
      users = []
      timestamp = DateTime.utc_now()

      assert render(
               MoonlapseWeb.UserView,
               "index.json",
               %{users: users, timestamp: timestamp}
             ) == %{
               timestamp: Calendar.strftime(timestamp, "%Y-%m-%d %H:%M:%S"),
               users: []
             }
    end

    test "fails with incorrect assigns" do
      assert_raise(Phoenix.Template.UndefinedError, fn ->
        render(
          MoonlapseWeb.UserView,
          "index.json",
          %{some_key: "INVALID"}
        )
      end)
    end
  end
end

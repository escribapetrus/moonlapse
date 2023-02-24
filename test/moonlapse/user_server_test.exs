defmodule Moonlapse.UserServerTest do
  use Moonlapse.DataCase

  alias Moonlapse.UserServer

  import Moonlapse.AccountsFixtures

  setup_all do
    UserServer.start_link([])

    :ok
  end

  describe "query_users" do
    test "fetches users and updates timestamp" do
      for x <- 1..100//10, do: user_fixture(%{points: x})
      {users, _timestamp} = UserServer.query_users()

      assert length(users) == 2
    end
  end

  describe "refresh" do
    test "updates user points and user_server min_number" do
      for x <- 1..100//10, do: user_fixture(%{points: x})
      send(UserServer, :refresh)
    end
  end
end

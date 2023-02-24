defmodule Moonlapse.AccountsTest do
  use Moonlapse.DataCase

  alias Moonlapse.Accounts

  describe "users" do
    import Moonlapse.AccountsFixtures

    test "get_users_by/1 returns users where points > min_points" do
      for x <- 11..20, do: user_fixture(%{points: x})
      users = Accounts.get_users_by(%{min_points: 12})

      assert length(users) == 8
      assert Enum.all?(users, &(&1.points > 12))
    end

    test "get_users_by/1 returns users where points > min_points with limit" do
      for x <- 11..20, do: user_fixture(%{points: x})

      users = Accounts.get_users_by(%{min_points: 12, limit: 2})

      assert length(users) == 2
      assert Enum.all?(users, &(&1.points > 12))
    end

    test "get_users_by/1 returns empty list" do
      for x <- 11..15, do: user_fixture(%{points: x})

      assert Accounts.get_users_by(%{min_points: 20}) == []
    end

    test "update_all_user_points/0 updates all users setting random points" do
      for x <- 1..10, do: user_fixture(%{points: x})

      Accounts.update_all_user_points()
    end
  end
end

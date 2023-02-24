defmodule Moonlapse.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Moonlapse.Accounts` context.
  """

  alias Moonlapse.Accounts.User
  alias Moonlapse.Repo

  @spec user_fixture(any) :: any
  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    params = Enum.into(attrs, %{points: 42})

    %User{}
    |> User.changeset(params)
    |> Repo.insert!()
  end
end

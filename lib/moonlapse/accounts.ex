defmodule Moonlapse.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Moonlapse.Accounts.User
  alias Moonlapse.Repo

  @doc "Get users with more points than a specified minimum"
  def get_users_by(%{min_points: min_points, limit: limit}) do
    query =
      from u in User,
        where: u.points > ^min_points,
        limit: ^limit,
        select: u

    Repo.all(query)
  end

  def get_users_by(%{min_points: min_points}) do
    query =
      from u in User,
        where: u.points > ^min_points,
        select: u

    Repo.all(query)
  end

  @doc "Updates all users with random points" 
  def update_all_user_points do
    User
    |> Repo.all()
    |> Task.async_stream(fn x -> update_user(x, %{points: :rand.uniform(101) - 1}) end)
    |> Stream.run()
  end

  defp update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end

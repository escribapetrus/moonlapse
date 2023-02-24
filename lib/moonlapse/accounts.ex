defmodule Moonlapse.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Moonlapse.Repo

  alias Moonlapse.Accounts.User

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

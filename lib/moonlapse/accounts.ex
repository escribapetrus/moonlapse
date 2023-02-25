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
      order_by: [desc: :points],
        select: u

    Repo.all(query)
  end

  def get_users_by(%{min_points: min_points}) do
    query =
      from u in User,
      where: u.points > ^min_points,
      order_by: [desc: :points],
      select: u

    Repo.all(query)
  end

  @spec update_all_user_points :: any
  @doc "Updates all users with random points" 
  def update_all_user_points() do
    from(u in User, update: [set: [points: fragment("floor(random() * (100 + 1))")]])
    |> Repo.update_all([])
  end
end

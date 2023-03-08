defmodule Moonlapse do
  @moduledoc """
  Moonlapse keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def points_limit, do: 100

  def rand_points(max), do: :rand.uniform(max + 1) - 1
end

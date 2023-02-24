defmodule MoonlapseWeb.UserView do
  use MoonlapseWeb, :view
  alias MoonlapseWeb.UserView

  def render("index.json", %{users: users, timestamp: timestamp}) do
    %{
      users: render_many(users, UserView, "user.json"),
      timestamp: Calendar.strftime(timestamp, "%Y-%m-%d %H:%M:%S")
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      points: user.points
    }
  end
end

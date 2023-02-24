defmodule MoonlapseWeb.UserController do
  use MoonlapseWeb, :controller

  def index(conn, _params) do
    {users, timestamp} = Moonlapse.UserPoints.query_users(2)
    render(conn, "index.json", users: users, timestamp: timestamp)
  end
end

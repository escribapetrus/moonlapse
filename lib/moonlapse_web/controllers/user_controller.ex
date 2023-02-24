defmodule MoonlapseWeb.UserController do
  use MoonlapseWeb, :controller

  def index(conn, _params) do
    {users, timestamp} = Moonlapse.UserServer.query_users()
    render(conn, "index.json", users: users, timestamp: timestamp)
  end
end

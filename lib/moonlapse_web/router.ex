defmodule MoonlapseWeb.Router do
  use MoonlapseWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MoonlapseWeb do
    pipe_through :api

    get "/", UserController, :index
  end
end

defmodule PharNote.Router do
  use PharNote.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PharNote do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", PharNote do
    pipe_through :api

    get "/users", UserController, :index

    #resources "/users", UserController, only: [:index]

  end
end

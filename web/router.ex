defmodule BlogTest.Router do
  use BlogTest.Web, :router


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

  scope "/", BlogTest do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController


  end

  scope "/auth", BlogTest do
    pipe_through :browser
    resources "/", AuthController
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlogTest do
  #   pipe_through :api
  # end
end

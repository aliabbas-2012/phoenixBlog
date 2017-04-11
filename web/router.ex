defmodule BlogTest.Router do
  use BlogTest.Web, :router


  pipeline :browser do
    plug :accepts, ["html","jpg"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BlogTest.Plugs.SetUser
    # plug BlogTest.SetStatic
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlogTest do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/auth-token-verification", PageController, :verify_token

    resources "/users", UserController
    resources "/categories", CategoryController
    resources "/posts", PostController
    resources "/rooms", RoomController
    resources "/images", ImageController
    resources "/profile", ProfileController,except: [:new,:index,:edit,:show,:update,:create,:delete]

    scope "/profile" do
      get "/edit", ProfileController,:edit
      put "/update", ProfileController,:update
      get "/show", ProfileController,:show
    end


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

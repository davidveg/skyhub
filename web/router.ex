defmodule Skyhub.Router do
  use Skyhub.Web, :router

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

  scope "/", Skyhub do
    pipe_through :browser # Use the default browser stack
    get "/images/generate", ImageController, :generate
    resources "/images", ImageController, only: [:index, :show, :delete, :image]
    get "/images/load/:id", ImageController, :image
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Skyhub do
    pipe_through :api
  end
end

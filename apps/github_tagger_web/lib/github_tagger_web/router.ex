defmodule GithubTaggerWeb.Router do
  use GithubTaggerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GithubTaggerWeb do
    pipe_through :api
  end
end

defmodule GithubTaggerWeb.Router do
  use GithubTaggerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(CORSPlug)
  end

  scope "/api", GithubTaggerWeb do
    pipe_through(:api)

    get("/users/:user/repositories", RepositoriesController, :index)
    post("/users/:user/repositories/fetch", RepositoriesController, :fetch)
  end
end

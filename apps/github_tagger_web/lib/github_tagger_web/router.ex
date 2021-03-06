defmodule GithubTaggerWeb.Router do
  use GithubTaggerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", GithubTaggerWeb do
    pipe_through(:api)

    get("/users/:user/repositories", RepositoriesController, :index)
    post("/users/:user/repositories/fetch", RepositoriesController, :fetch)
    patch("/users/:user/repositories/:id", RepositoriesController, :update)
  end
end

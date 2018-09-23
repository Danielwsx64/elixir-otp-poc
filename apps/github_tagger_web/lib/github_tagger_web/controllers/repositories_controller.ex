defmodule GithubTaggerWeb.RepositoriesController do
  use GithubTaggerWeb, :controller

  alias GithubTagger.Storage.UserServer
  alias GithubTagger.User.Repository

  def index(conn, %{"user" => user}) do
    {:ok, repositories} = UserServer.lookup(user)

    repos_as_struct = Enum.map(repositories, &Repository.from_raw/1)

    json(conn, repos_as_struct)
  end
end

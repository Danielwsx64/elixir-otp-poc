defmodule GithubTaggerWeb.RepositoriesController do
  use GithubTaggerWeb, :controller

  alias GithubTagger.Storage.UserServer
  alias GithubTagger.User.Repository
  alias GithubTagger.User.Fetcher

  def index(conn, %{"user" => user}) do
    {:ok, repositories} = UserServer.lookup(user)

    repos_as_struct = Enum.map(repositories, &Repository.from_raw/1)

    json(conn, repos_as_struct)
  end

  def fetch(conn, %{"user" => user}) do
    repositories = Fetcher.starred_repositories(user)

    storaged_repositories =
      repositories
      |> Enum.map(fn repo -> Repository.sanitize(repo) end)
      |> Enum.map(fn repo -> UserServer.store({user, repo}) end)
      |> Enum.map(fn {:ok, repo} -> Repository.from_raw(repo) end)

    json(conn, storaged_repositories)
  end
end

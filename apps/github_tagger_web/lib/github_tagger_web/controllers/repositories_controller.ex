defmodule GithubTaggerWeb.RepositoriesController do
  use GithubTaggerWeb, :controller

  alias GithubTagger.Storage.UserServer
  alias GithubTagger.User.Repository
  alias GithubTagger.User.Fetcher

  def index(conn, %{"user" => user}) do
    {:ok, repositories} = UserServer.lookup(user)

    json(conn, repositories)
  end

  def fetch(conn, %{"user" => user}) do
    repositories = Fetcher.starred_repositories(user)

    storaged_repositories =
      repositories
      |> Enum.map(fn repo -> Repository.from_json(repo) end)
      |> Enum.map(fn repo -> UserServer.store(user, repo) end)
      |> Enum.map(fn {:ok, repo} -> repo end)

    json(conn, storaged_repositories)
  end

  def update(conn, %{"user" => user, "id" => id, "tags" => tags} = tt) do
    id
    |> find_repository(user)
    |> update_repository_tags(tags)
    |> ets_update_repository(user)
    |> case do
      {:ok, _} -> put_status(conn, :no_content)
      {:error, "repository not found"} -> put_status(conn, :not_found)
    end
  end

  defp find_repository(repository_id, user) do
    case UserServer.lookup_repository(user, repository_id) do
      {:ok, %Repository{}} = repository -> repository
      {:ok, []} -> {:error, "repository not found"}
    end
  end

  defp update_repository_tags({:error, _} = error), do: error

  defp update_repository_tags(%Repository{} = repository, tags) do
    updated_repository = Repository.update_tags(repository, tags)
  end

  defp ets_update_repository({:error, _} = error), do: error

  defp ets_update_repository(%Repository{} = repository, user) do
    UserServer.updated_repository(user, repository)
  end
end

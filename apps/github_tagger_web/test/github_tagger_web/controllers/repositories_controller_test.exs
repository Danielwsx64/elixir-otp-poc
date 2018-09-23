defmodule GithubTaggerWeb.RepositoriesControllerTest do
  use GithubTaggerWeb.ConnCase

  alias GithubTagger.Storage.UserServer
  alias GithubTagger.User.Repository

  describe "index" do
    test "return user repositories", %{conn: conn} do
      user = "danielws"

      repo_one = %{
        "id" => 1,
        "name" => "awesome_app",
        "description" => "awesome_app repo",
        "url" => "http://github/daniel/awesome_app",
        "language" => "elixir"
      }

      repo_two = %{
        "id" => 2,
        "name" => "awesome_app2",
        "description" => "awesome_app repo2",
        "url" => "http://github/daniel/awesome_app2",
        "language" => "elixir"
      }

      struct_repo_one =
        repo_one
        |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
        |> Enum.into(%{})

      struct_repo_two =
        repo_two
        |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
        |> Enum.into(%{})

      UserServer.store({user, struct(Repository, struct_repo_one)})
      UserServer.store({user, struct(Repository, struct_repo_two)})

      response =
        conn
        |> get("api/users/#{user}/repositories")
        |> json_response(200)

      assert response == [repo_two, repo_one]
    end
  end
end

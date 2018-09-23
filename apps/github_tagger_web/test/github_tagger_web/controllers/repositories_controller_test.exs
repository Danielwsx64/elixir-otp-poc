defmodule GithubTaggerWeb.RepositoriesControllerTest do
  use GithubTaggerWeb.ConnCase

  alias GithubTagger.Storage.UserServer
  alias GithubTagger.User.Repository

  setup do
    UserServer.clean()
  end

  describe "index/2" do
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

    test "return an empty json when user has no repositories", %{conn: conn} do
      user = "danielws"

      response =
        conn
        |> get("api/users/#{user}/repositories")
        |> json_response(200)

      assert response == []
    end
  end

  describe "fetch/2" do
    test "return user repositories", %{conn: conn} do
      user = "danielwsx64"

      expected_repos = [
        %{
          "description" => "A docker enviroment to development with Laravel",
          "id" => 110_260_502,
          "language" => "Shell",
          "name" => "laravel-docker-image",
          "url" => "https://github.com/Danielwsx64/laravel-docker-image"
        },
        %{
          "description" => "My Dotfiles =D",
          "id" => 90_383_587,
          "language" => "Shell",
          "name" => "ws_dotfiles",
          "url" => "https://github.com/Danielwsx64/ws_dotfiles"
        }
      ]

      response =
        conn
        |> post("api/users/#{user}/repositories/fetch")
        |> json_response(200)

      assert response == expected_repos
    end

    test "return an empty json when user has no repositories", %{conn: conn} do
      user = "some_no_existing_user"

      response =
        conn
        |> post("api/users/#{user}/repositories/fetch")
        |> json_response(200)

      assert response == []
    end
  end
end

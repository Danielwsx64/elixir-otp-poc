defmodule GithubTagger.Storage.UserServerTest do
  use ExUnit.Case

  alias GithubTagger.Storage.UserServer
  alias GithubTagger.User.Repository

  setup do
    UserServer.clean()
  end

  test "supervisor and genserver are connected" do
    {_, {message, _pid}} = UserServer.start_link()
    assert message == :already_started
  end

  describe "clean/0" do
    test "clean all repositories table" do
      user = "daniel"

      repo_one = %Repository{
        id: 1,
        name: "awesome_app",
        description: "awesome_app repo",
        url: "http://github/daniel/awesome_app",
        language: "elixir"
      }

      UserServer.store({user, repo_one})

      assert {:ok, []} == UserServer.clean()
      assert {:ok, []} == UserServer.lookup(user)
    end
  end

  describe "store/1" do
    test "store given user and return ok with raw data" do
      user = "daniel"

      repo_one = %Repository{
        id: 1,
        name: "awesome_app",
        description: "awesome_app repo",
        url: "http://github/daniel/awesome_app",
        language: "elixir"
      }

      repo_two = %Repository{
        id: 2,
        name: "awesome_app2",
        description: "awesome_app repo2",
        url: "http://github/daniel/awesome_app2",
        language: "elixir"
      }

      raw_repo =
        {1, "awesome_app", "awesome_app repo", "http://github/daniel/awesome_app", "elixir"}

      assert {:ok, raw_repo} == UserServer.store({user, repo_one})
      assert {:ok, _} = UserServer.store({user, repo_two})
    end

    test "return error when try add existing repository" do
      # TODO
      user = "daniel"

      repo = %Repository{
        id: 1,
        name: "awesome_app",
        description: "awesome_app repo",
        url: "http://github/daniel/awesome_app",
        language: "elixir"
      }

      UserServer.store({user, repo})
      # assert {:error, "fail to insert repository"} = UserServer.store({user, repo}, pid)
    end
  end

  describe "lookup/1" do
    test "return user repositories" do
      user = "daniel"

      repo_one = %Repository{
        id: 1,
        name: "awesome_app",
        description: "awesome_app repo",
        url: "http://github/daniel/awesome_app",
        language: "elixir"
      }

      repo_two = %Repository{
        id: 2,
        name: "another_awesome_app",
        description: "another_awesome_app repo",
        url: "http://github/daniel/another_awesome_app",
        language: "ruby"
      }

      UserServer.store({user, repo_one})
      UserServer.store({user, repo_two})

      expected_repos = [Repository.to_raw(repo_two), Repository.to_raw(repo_one)]
      assert UserServer.lookup(user) == {:ok, expected_repos}
    end
  end
end

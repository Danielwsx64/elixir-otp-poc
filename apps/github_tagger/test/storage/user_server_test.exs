defmodule GithubTagger.Storage.UserServerTest do
  use ExUnit.Case

  alias GithubTagger.Storage.UserServer
  alias GithubTagger.User.Repository

  describe "start_link/1" do
    test "should start a server" do
      name = :test_server

      assert {:ok, pid} = UserServer.start_link(name)
      assert Process.info(pid, :registered_name) == {:registered_name, name}
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

      {:ok, pid} = UserServer.start_link()

      raw_repo =
        {1, "awesome_app", "awesome_app repo", "http://github/daniel/awesome_app", "elixir"}

      assert {:ok, raw_repo} == UserServer.store({user, repo_one}, pid)
      assert {:ok, _} = UserServer.store({user, repo_two}, pid)
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

      {:ok, pid} = UserServer.start_link()
      UserServer.store({user, repo_one}, pid)
      UserServer.store({user, repo_two}, pid)

      expected_repos = [Repository.to_raw(repo_two), Repository.to_raw(repo_one)]
      assert UserServer.lookup(user) == {:ok, expected_repos}
    end
  end
end

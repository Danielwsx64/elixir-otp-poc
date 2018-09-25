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
        language: "elixir",
        tags: []
      }

      UserServer.store(user, repo_one)

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
        language: "elixir",
        tags: []
      }

      repo_two = %Repository{
        id: 2,
        name: "awesome_app2",
        description: "awesome_app repo2",
        url: "http://github/daniel/awesome_app2",
        language: "elixir",
        tags: []
      }

      assert {:ok, repo_one} == UserServer.store(user, repo_one)
      assert {:ok, _} = UserServer.store(user, repo_two)
    end

    test "return error when try add existing repository" do
      # TODO
      user = "daniel"

      repo = %Repository{
        id: 1,
        name: "awesome_app",
        description: "awesome_app repo",
        url: "http://github/daniel/awesome_app",
        language: "elixir",
        tags: []
      }

      UserServer.store(user, repo)
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
        language: "elixir",
        tags: []
      }

      repo_two = %Repository{
        id: 2,
        name: "another_awesome_app",
        description: "another_awesome_app repo",
        url: "http://github/daniel/another_awesome_app",
        language: "ruby",
        tags: []
      }

      UserServer.store(user, repo_one)
      UserServer.store(user, repo_two)

      expected_repos = [repo_one, repo_two]
      assert UserServer.lookup(user) == {:ok, expected_repos}
    end
  end

  describe "lookup_repository/2" do
    test "return correct repository" do
      user = "daniel"

      repo_one = %Repository{
        id: 1,
        name: "awesome_app",
        description: "awesome_app repo",
        url: "http://github/daniel/awesome_app",
        language: "elixir",
        tags: []
      }

      repo_two = %Repository{
        id: 2,
        name: "another_awesome_app",
        description: "another_awesome_app repo",
        url: "http://github/daniel/another_awesome_app",
        language: "ruby",
        tags: ["tag1", "tag2"]
      }

      UserServer.store(user, repo_one)
      UserServer.store(user, repo_two)

      assert UserServer.lookup_repository(user, repo_two.id) == {:ok, repo_two}
    end
  end

  describe "update_repository/2" do
    test "update the given repository" do
      user = "daniel"

      original_repository = %Repository{
        id: 1,
        name: "awesome_app",
        description: "awesome_app repo",
        url: "http://github/daniel/awesome_app",
        language: "elixir",
        tags: []
      }

      UserServer.store(user, original_repository)

      updated_repository = Map.merge(original_repository, %{tags: ["tag1", "tag2"]})

      assert {:ok, updated_repository} == UserServer.updated_repository(user, updated_repository)

      expected_repositories = [updated_repository]

      assert UserServer.lookup(user) == {:ok, expected_repositories}
    end
  end
end

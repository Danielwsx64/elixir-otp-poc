defmodule GithubTagger.User.RepositoryTest do
  use ExUnit.Case

  alias GithubTagger.User.Repository

  test "test struct" do
    assert %{id: nil, name: nil, description: nil, url: nil, language: nil} = %Repository{}
  end

  describe "to_raw/1" do
    test "return raw repo data" do
      repo = %Repository{
        id: 1,
        name: "app",
        description: "better app",
        url: "github.com",
        language: "elixir"
      }

      expected_raw = {1, "app", "better app", "github.com", "elixir"}

      assert Repository.to_raw(repo) == expected_raw
    end
  end

  describe "from_raw/1" do
    test "return raw repo data" do
      raw = {1, "app", "better app", "github.com", "elixir"}

      expected_repo = %Repository{
        id: 1,
        name: "app",
        description: "better app",
        url: "github.com",
        language: "elixir"
      }

      assert Repository.from_raw(raw) == expected_repo
    end
  end
end

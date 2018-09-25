defmodule GithubTagger.User.FetcherTest do
  use ExUnit.Case

  alias GithubTagger.User.Fetcher

  describe "starred_repositories/1" do
    test "get user starred repositories" do
      user = "danielwsx64"

      repositories = ["ws_dotfiles", "laravel-docker-image"]
      result = Fetcher.starred_repositories(user) |> Enum.map(& &1["name"])
      assert result == repositories
    end

    test "return an empty list when user has no starred repositories" do
      user = "some_inexisting_user"

      repositories = []
      assert Fetcher.starred_repositories(user) == repositories
    end
  end
end

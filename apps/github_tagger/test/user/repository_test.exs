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
    test "return repository struct" do
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

  describe "sanitize/1" do
    test "return repository struct" do
      input_repo = %{
        "some_attr" => "some_value_1",
        "id" => 1,
        "name" => "app",
        "description" => "better app",
        "html_url" => "github.com",
        "language" => "elixir",
        "some_attr_2" => "some_value_2"
      }

      expected_repo = %Repository{
        id: 1,
        name: "app",
        description: "better app",
        url: "github.com",
        language: "elixir"
      }

      assert Repository.sanitize(input_repo) == expected_repo
    end
  end
end

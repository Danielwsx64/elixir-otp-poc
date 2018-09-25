defmodule GithubTagger.User.RepositoryTest do
  use ExUnit.Case

  alias GithubTagger.User.Repository

  test "test struct" do
    assert %{id: nil, name: nil, description: nil, url: nil, language: nil, tags: []} =
             %Repository{}
  end

  describe "update_tags/1" do
    test "include new tags" do
      repo = %Repository{
        id: 1,
        name: "app",
        description: "better app",
        url: "github.com",
        language: "elixir",
        tags: []
      }

      tags = ["tag1", "tag2"]

      expected_repo = Map.merge(repo, %{tags: tags})

      assert Repository.update_tags(repo, tags) == expected_repo
    end
  end

  describe "to_tuple/1" do
    test "return raw repo data" do
      repo = %Repository{
        id: 1,
        name: "app",
        description: "better app",
        url: "github.com",
        language: "elixir",
        tags: []
      }

      expected_raw = {1, "app", "better app", "github.com", "elixir", []}

      assert Repository.to_tuple(repo) == expected_raw
    end

    test "return raw repo data with tags" do
      repo = %Repository{
        id: 1,
        name: "app",
        description: "better app",
        url: "github.com",
        language: "elixir",
        tags: ["tag1", "tag2"]
      }

      expected_raw = {1, "app", "better app", "github.com", "elixir", ["tag1", "tag2"]}

      assert Repository.to_tuple(repo) == expected_raw
    end
  end

  describe "from_tuple/1" do
    test "return repository struct" do
      raw = {1, "app", "better app", "github.com", "elixir", []}

      expected_repo = %Repository{
        id: 1,
        name: "app",
        description: "better app",
        url: "github.com",
        language: "elixir",
        tags: []
      }

      assert Repository.from_tuple(raw) == expected_repo
    end

    test "return repository struct with tags" do
      raw = {1, "app", "better app", "github.com", "elixir", ["tag1", "tag2"]}

      expected_repo = %Repository{
        id: 1,
        name: "app",
        description: "better app",
        url: "github.com",
        language: "elixir",
        tags: ["tag1", "tag2"]
      }

      assert Repository.from_tuple(raw) == expected_repo
    end
  end

  describe "from_list/1" do
    test "return repository struct" do
      list = [1, "app", "better app", "github.com", "elixir", []]

      expected_repo = %Repository{
        id: 1,
        name: "app",
        description: "better app",
        url: "github.com",
        language: "elixir",
        tags: []
      }

      assert Repository.from_list(list) == expected_repo
    end

    test "return repository struct with tags" do
      list = [1, "app", "better app", "github.com", "elixir", ["tag1", "tag2"]]

      expected_repo = %Repository{
        id: 1,
        name: "app",
        description: "better app",
        url: "github.com",
        language: "elixir",
        tags: ["tag1", "tag2"]
      }

      assert Repository.from_list(list) == expected_repo
    end

    test "return an empty list when a empty list is given" do
      list = []

      assert Repository.from_list(list) == []
    end
  end

  describe "from_json/1" do
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
        language: "elixir",
        tags: []
      }

      assert Repository.from_json(input_repo) == expected_repo
    end
  end
end

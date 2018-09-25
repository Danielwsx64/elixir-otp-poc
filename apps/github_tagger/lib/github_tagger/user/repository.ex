defmodule GithubTagger.User.Repository do
  defstruct [:id, :name, :description, :url, :language, tags: []]

  def update_tags(%__MODULE__{} = repository, tags) when is_list(tags),
    do: Map.merge(repository, %{tags: tags})

  def to_tuple(%__MODULE__{
        id: id,
        name: name,
        description: description,
        url: url,
        language: language,
        tags: tags
      }),
      do: {id, name, description, url, language, tags}

  def from_tuple({id, name, description, url, language, tags}),
    do: %__MODULE__{
      id: id,
      name: name,
      description: description,
      url: url,
      language: language,
      tags: tags
    }

  def from_list([]), do: []

  def from_list([id, name, description, url, language, tags]),
    do: %__MODULE__{
      id: id,
      name: name,
      description: description,
      url: url,
      language: language,
      tags: tags
    }

  def from_json(%{
        "id" => id,
        "name" => name,
        "description" => description,
        "html_url" => url,
        "language" => language
      }),
      do: %__MODULE__{id: id, name: name, description: description, url: url, language: language}
end

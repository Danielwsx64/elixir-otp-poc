defmodule GithubTagger.User.Repository do
  defstruct [:id, :name, :description, :url, :language]

  def to_raw(%__MODULE__{
        id: id,
        name: name,
        description: description,
        url: url,
        language: language
      }),
      do: {id, name, description, url, language}

  def from_raw({id, name, description, url, language}),
    do: %__MODULE__{id: id, name: name, description: description, url: url, language: language}

  def sanitize(%{
        "id" => id,
        "name" => name,
        "description" => description,
        "html_url" => url,
        "language" => language
      }),
      do: %__MODULE__{id: id, name: name, description: description, url: url, language: language}
end

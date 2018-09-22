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
end

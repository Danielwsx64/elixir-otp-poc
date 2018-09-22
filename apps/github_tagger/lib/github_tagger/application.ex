defmodule GithubTagger.Application do
  @moduledoc """
  The GithubTagger Application Service.

  The github_tagger system business domain lives in this application.

  Exposes API to clients such as the `GithubTaggerWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      
    ], strategy: :one_for_one, name: GithubTagger.Supervisor)
  end
end

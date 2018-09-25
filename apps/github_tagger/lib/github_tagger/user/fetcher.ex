defmodule GithubTagger.User.Fetcher do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.github.com/users/")
  plug(Tesla.Middleware.Headers, [{"User-Agent", "GithubTagger"}])
  plug(Tesla.Middleware.JSON)

  def starred_repositories(user) when is_bitstring(user) do
    user
    |> get_starred_repositories()
    |> extract_response()
  end

  defp get_starred_repositories(user) do
    get(user <> "/starred")
  end

  defp extract_response({:ok, %{status: 200, body: response}}), do: response
  defp extract_response(_), do: []
end

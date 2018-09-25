require IEx

defmodule GithubTagger.Storage.UserServer do
  use GenServer

  alias GithubTagger.User.Repository

  # Client
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def clean do
    GenServer.call(__MODULE__, :clean)
  end

  def store(user, %Repository{} = repo) when is_bitstring(user) do
    GenServer.call(__MODULE__, [:store, user, repo])
  end

  def lookup(user) when is_bitstring(user) do
    GenServer.call(__MODULE__, [:lookup, user])
  end

  def lookup_repository(user, repo_id) when is_bitstring(user) do
    GenServer.call(__MODULE__, [:lookup_repository, user, repo_id])
  end

  def updated_repository(user, repository) when is_bitstring(user) do
    GenServer.call(__MODULE__, [:update_repository, user, repository])
  end

  # Server
  def init(_) do
    {:ok, {create_table()}}
  end

  def handle_call([:store, user, repo], _from, {table}) do
    ets_store(user, repo, table)

    {:reply, {:ok, repo}, {table}}
  end

  def handle_call([:lookup, user], _from, {table}) do
    repositories = user_repositories_from_ets(user, table)

    {:reply, {:ok, repositories}, {table}}
  end

  def handle_call([:lookup_repository, user, repository_id], _from, {table}) do
    repository = user_repository_from_ets(user, repository_id, table)

    {:reply, {:ok, repository}, {table}}
  end

  def handle_call([:update_repository, user, repository], _from, {table}) do
    ets_delete_repo(user, repository.id, table)
    ets_store(user, repository, table)

    {:reply, {:ok, repository}, {table}}
  end

  def handle_call(:clean, _from, {table}) do
    :ets.delete(table)

    {:reply, {:ok, []}, {create_table()}}
  end

  defp create_table, do: :ets.new(:user_repositories, [:bag, :private])

  defp ets_store(user, %Repository{} = repo, table) do
    repo
    |> Repository.to_tuple()
    |> ets_add_repo(user, table)
  end

  defp ets_add_repo(repo, user, table) do
    if :ets.insert(table, {user, repo}),
      do: {:ok, repo},
      else: {:error, "fail to insert repository"}
  end

  defp ets_delete_repo(user, repository_id, table) do
    pattern = {user, {repository_id, :_, :_, :_, :_, :_}}
    :ets.match_delete(table, pattern)
  end

  defp user_repository_from_ets(user, repository_id, table) do
    pattern = {user, {:"$1", :"$2", :"$3", :"$4", :"$5", :"$6"}}
    condition = [{:==, :"$1", repository_id}]
    format = [:"$$"]

    :ets.select(table, [{pattern, condition, format}])
    |> Enum.reduce([], fn repo, _ -> repo end)
    |> Repository.from_list()
  end

  defp user_repositories_from_ets(user, table) do
    :ets.match(table, {user, :"$1"})
    |> Enum.map(fn [repo] -> Repository.from_tuple(repo) end)
  end
end

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

  def store({user, %Repository{}} = data) when is_bitstring(user) do
    GenServer.call(__MODULE__, [:store, data])
  end

  def lookup(user) when is_bitstring(user) do
    GenServer.call(__MODULE__, [:lookup, user])
  end

  # Server
  def init(_) do
    {:ok, {create_table()}}
  end

  def handle_call([:store, {user, repo}], _from, {table}) do
    result = ets_store({user, repo}, table)

    {:reply, result, {table}}
  end

  def handle_call([:lookup, user], _from, {table}) do
    repositories = get_storaged_repos(user, table)

    {:reply, {:ok, repositories}, {table}}
  end

  def handle_call(:clean, _from, {table}) do
    :ets.delete(table)

    {:reply, {:ok, []}, {create_table()}}
  end

  defp create_table, do: :ets.new(:user_repositories, [:private])

  defp ets_store({user, %Repository{} = repo}, table) do
    repo
    |> Repository.to_raw()
    |> ets_add_repo(user, table)
  end

  defp ets_add_repo(repo, user, table) do
    repositories = get_storaged_repos(user, table)

    updated_repos = [repo] ++ repositories

    if :ets.insert(table, {user, updated_repos}),
      do: {:ok, repo},
      else: {:error, "fail to insert repository"}
  end

  defp get_storaged_repos(user, table) do
    case :ets.lookup(table, user) do
      [{user, repos}] -> repos
      _ -> []
    end
  end
end

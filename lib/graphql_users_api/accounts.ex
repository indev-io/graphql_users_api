defmodule GraphqlUsersApi.Accounts do
  alias GraphqlUsersApi.Accounts.User
  alias GraphqlUsersApi.Accounts.Preference
  alias EctoShorts.Actions

  def list_users(params \\ %{}) do
    ids = Actions.all(Preference, params) |> Enum.map(fn %{id: id} -> id end)
    list = Actions.all(User, params) |> Enum.filter(fn %{id: id} -> Enum.member?(ids, id) end)
    {:ok, list}
  end

  def find_user(params) do
    Actions.find(User, params)
  end

  def update_user(id, params) do
    Actions.update(User, id, params)
  end

  def create_user(params) do
    Actions.create(User, params)
  end

  def update_user_preferences(id, params) do
    Actions.update(Preference, id, params)
  end
end

defmodule GraphqlUsersApi.Accounts do
  alias GraphqlUsersApi.Accounts.User
  alias GraphqlUsersApi.Accounts.Preference
  alias EctoShorts.Actions

  @possible_preferences [:likes_emails, :likes_faxes, :likes_phone_calls]

  def list_users(params) do
    if has_at_least_one_key(params, @possible_preferences) do
      {preferences, params} = Map.split(params, @possible_preferences)
      users = User |> Preference.join_preferences() |> Preference.by_preferences(preferences) |> Actions.all(params)
      {:ok, users}
    else
      users = Actions.all(User, params)
      {:ok, users}
    end
  end

  defp has_at_least_one_key(map, list_of_keys) do
    Enum.any?(list_of_keys, &Map.has_key?(map, &1))
  end

  @spec find_user(keyword() | map()) :: {:error, any()} | {:ok, %{optional(atom()) => any()}}
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

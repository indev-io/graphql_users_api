defmodule GraphqlUsersApi.Accounts do
  alias GraphqlUsersApi.Accounts.User
  alias GraphqlUsersApi.Accounts.Preference
  alias EctoShorts.Actions

  def list_users(params \\ %{}) do
    query = Enum.reduce(params, User, &convert_field_to_query/2)
    users = Actions.all(query, params)
    {:ok, users}
  end

  defp convert_field_to_query({:name, value}, query)do
    User.by_name(query, value)
  end

  defp convert_field_to_query({:email, value}, query) do
    User.by_email(query, value)
  end

  defp convert_field_to_query({:likes_emails, value}, query) do
    User.by_likes_emails(query, value)
  end

  defp convert_field_to_query({:likes_faxes, value}, query) do
    User.by_likes_faxes(query, value)
  end

  defp convert_field_to_query({:likes_phone_calls, value}, query) do
    User.by_likes_phone_calls(query, value)
  end

  defp convert_field_to_query(_, query) do
    query
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

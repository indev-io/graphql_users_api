defmodule GraphqlUsersApi.Accounts do
  import Ecto.Query, only: [from: 2]
  alias GraphqlUsersApi.Accounts.User
  alias GraphqlUsersApi.Accounts.Preference
  alias EctoShorts.Actions

  def list_users(params \\ %{}) do
    query = from u in User, join: p in assoc(u, :preferences), preload: [preferences: p]

    query =
     query
     |> maybe_likes_emails(params)
     |> maybe_likes_faxes(params)
     |> maybe_likes_phone_calls(params)
     |> maybe_before(params)
     |> maybe_after(params)
     |> maybe_first(params)

    users = Actions.all(query)
    {:ok, users}
  end

  defp maybe_likes_emails(query, params) do
    if Map.has_key?(params, :likes_emails) do
      from [u, p] in query, where: p.likes_emails == ^params.likes_emails
    else
      query
    end
  end

  defp maybe_likes_faxes(query, params) do
    if Map.has_key?(params, :likes_faxes) do
      from [u, p] in query, where: p.likes_faxes == ^params.likes_faxes
    else
      query
    end
  end

  defp maybe_likes_phone_calls(query, params) do
    if Map.has_key?(params, :likes_phone_calls) do
      from [u, p] in query, where: p.likes_phone_calls == ^params.likes_phone_calls
    else
      query
    end
  end

  defp maybe_before(query, params) do
    if Map.has_key?(params, :before) do
      from [u, p] in query, where: u.id < ^params.before
    else
      query
    end
  end

  defp maybe_after(query, params) do
    if Map.has_key?(params, :after) do
      from [u, p] in query, where: p.id > ^params.after
    else
      query
    end
  end

  defp maybe_first(query, params) do
    if Map.has_key?(params, :first) do
      from [u, p] in query, limit: ^params.first
    else
      query
    end
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

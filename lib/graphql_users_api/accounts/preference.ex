defmodule GraphqlUsersApi.Accounts.Preference do
  alias GraphqlUsersApiWeb.Accounts.User
  import Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset

  schema "preferences" do
    field :likes_emails, :boolean, default: false
    field :likes_phone_calls, :boolean, default: false
    field :likes_faxes, :boolean, default: false

  end

  def create_changeset(params) do
    changeset(%GraphqlUsersApi.Accounts.Preference{}, params)
  end

  @available_fields [:likes_emails, :likes_phone_calls, :likes_faxes]
  @doc false
  def changeset(preference, attrs) do
    preference
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
  end

  def by_preferences(query \\ from(), preferences) do
    Enum.reduce(preferences, query, &convert_field_to_query/2)
  end

  def from(query \\ User), do: from(query, as: :user)

  def by_likes_emails(query \\ from(), bool), do: where(query, [preference: p], p.likes_emails == ^bool)
  def by_likes_faxes(query \\ from() ,bool), do: where(query, [preference: p], p.likes_faxes == ^bool)
  def by_likes_phone_calls(query \\ from(), bool), do: where(query, [preference: p], p.likes_phone_calls == ^bool)

  defp convert_field_to_query({:likes_emails, value}, query), do: by_likes_emails(query, value)
  defp convert_field_to_query({:likes_faxes, value}, query), do: by_likes_faxes(query, value)
  defp convert_field_to_query({:likes_phone_calls, value}, query), do: by_likes_phone_calls(query, value)

end

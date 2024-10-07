defmodule GraphqlUsersApi.Accounts.Preference do
  alias GraphqlUsersApi.Accounts.Preference
  import Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset

  schema "preferences" do
    field :likes_emails, :boolean, default: false
    field :likes_phone_calls, :boolean, default: false
    field :likes_faxes, :boolean, default: false
    belongs_to :user, GraphqlUsersApi.Accounts.User

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

  def from(query \\ Preference), do: from(query, as: :preference)
  def by_preferences(query \\ from(), preferences) do
    Enum.reduce(preferences, query, fn {field, value}, acc -> by_preference(acc, field, value) end)
  end

  def by_preference(query \\ from(), field, bool) do
    where(query, [preference: p], field(p, ^field) == ^bool)
  end

  def join_preferences(query) do
    from u in query, preload: :preferences,
    join: p in assoc(u, :preferences), as: :preference
  end

end

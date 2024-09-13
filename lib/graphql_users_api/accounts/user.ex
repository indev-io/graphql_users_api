defmodule GraphqlUsersApi.Accounts.User do
  import Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    belongs_to :preferences, GraphqlUsersApi.Accounts.Preference
  end
  @available_fields [:name, :email]

  @spec create_changeset(
          :invalid
          | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def create_changeset(params) do
    changeset(%GraphqlUsersApi.Accounts.User{}, params)
  end
  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
    |> cast_assoc(:preferences)
  end

  def by_likes_faxes(query, bool) do
    query = maybe_join_preferences(query)
    from [u, p] in query, where: p.likes_faxes == ^bool
  end

  def by_likes_emails(query , bool) do
    query = maybe_join_preferences(query)
    from [u, p] in query, where: p.likes_emails == ^bool
  end

  def by_likes_phone_calls(query, bool) do
    query = maybe_join_preferences(query)
    from [u, p] in query, where: p.likes_phone_calls == ^bool
  end

  def by_name(query \\ GraphqlUsersApi.Accounts.User, val) do
    where(query, [u], u.name == ^val)
  end

  @spec by_email(any(), any()) :: Ecto.Query.t()
  def by_email(query \\ GraphqlUsersApi.Accounts.User, val) do
    where(query, [u], u.email == ^val)
  end


  # def join_preferences(query \\ GraphqlUsersApi.Accounts.User) do
  #   query = preload(query, :preferences)
  #   join(query, :inner, [u], p in assoc(u, :preferences), as: :preferences)
  # end

  #running this function returns unknown bind name :preferences in query when testing in graphiql playground,
  #yet works when testing through IEX

  # def by_likes_phone_calls(query \\ join_preferences(), bool) do
  #   where(query, [u, preferences: p], p.likes_phone_calls == ^bool)
  # end

  defp maybe_join_preferences(query) do
    cond do
      #guard against User used in accumulator
      !is_map(query) ->
      from u in query, preload: :preferences, join: p in assoc(u, :preferences)
      !Keyword.has_key?(query.assocs, :preferences) ->
      from u in query, preload: :preferences, join: p in assoc(u, :preferences)
      true -> query
    end
  end

end

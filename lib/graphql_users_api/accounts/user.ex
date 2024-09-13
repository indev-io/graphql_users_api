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
    GraphqlUsersApi.Repo.preload([:preferences])
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
    |> cast_assoc(:preferences)
  end

  def by_likes_faxes(query \\ GraphqlUsersApi.Accounts.User, bool) do
    query = maybe_join_preferences(query)
    from [u, p] in query, where: p.likes_faxes == ^bool
  end

  def by_likes_emails(query \\ GraphqlUsersApi.Accounts.User, bool) do
    query = maybe_join_preferences(query)
    from [u, p] in query, where: p.likes_emails == ^bool
  end

  def by_likes_phone_calls(query \\ GraphqlUsersApi.Accounts.User, bool) do
    query = maybe_join_preferences(query)
    from [u, p] in query, where: p.likes_phone_calls == ^bool
  end

  def by_name(query \\ GraphqlUsersApi.Accounts.User, val) do
    IO.inspect(query)
    where(query, [u], u.name == ^val)
  end

  @spec by_email(any(), any()) :: Ecto.Query.t()
  def by_email(query \\ GraphqlUsersApi.Accounts.User, val) do
    where(query, [u], u.email == ^val)
  end

  # def join_preferences(query \\ GraphqlUsersApi.Accounts.User) do
  #   join(query, :inner, [u], p in assoc(u, :preferences), as: :preferences)
  # end

  defp maybe_join_preferences(query) do
    cond do
      !is_map(query) ->
      from u in query, join: p in assoc(u, :preferences)
      !Keyword.has_key?(query.assocs, :preferences) ->
      from u in query, join: p in assoc(u, :preferences)
      true -> query
    end
  end



end

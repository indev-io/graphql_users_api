defmodule GraphqlUsersApi.Accounts.User do
  import Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset
  alias GraphqlUsersApi.Accounts.User

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


  def join_preferences(query \\ User) do
    from u in query, preload: :preferences,
    join: p in assoc(u, :preferences), as: :preference
  end

end

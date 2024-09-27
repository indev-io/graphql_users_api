defmodule GraphqlUsersApi.Accounts.User do
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

end

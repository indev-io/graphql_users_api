defmodule GraphqlUsersApi.Accounts.Preference do
  use Ecto.Schema
  import Ecto.Changeset

  schema "preferences" do
    field :likes_emails, :boolean, default: false
    field :likes_phone_calls, :boolean, default: false
    field :likes_faxes, :boolean, default: false

    # belongs_to :user, GraphqlUsersApi.Accounts.User
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
end

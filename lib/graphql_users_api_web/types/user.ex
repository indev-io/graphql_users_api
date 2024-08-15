defmodule GraphqlUsersApiWeb.Types.User do
  use Absinthe.Schema.Notation
  @desc "A user that has a name, email, and preferences"
  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :preferences, non_null(:preferences)
  end

  @desc "Prefences about how the user likes to be contacted"
  object :preferences do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end

  @desc "input_object about how the user likes to be contacted"
  input_object :preferences_filter do
    field :likes_emails, non_null(:boolean)
    field :likes_phone_calls, non_null(:boolean)
    field :likes_faxes, non_null(:boolean)
  end
end

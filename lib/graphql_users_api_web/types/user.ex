defmodule GraphqlUsersApiWeb.Types.User do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "Prefences about how the user likes to be contacted"
  object :preferences do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
    field :id, :id
  end

  @desc "A user that has a name, email, and preferences"
  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :preferences, non_null(:preferences), resolve: dataloader(GraphqlUsersApi.Accounts, :preferences)
  end



  @desc "input_object about how the user likes to be contacted"
  input_object :preferences_filter do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
    field :id, :id
  end
end

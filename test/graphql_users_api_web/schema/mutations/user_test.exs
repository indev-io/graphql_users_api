defmodule GraphqlUsersApiWeb.Schema.Mutations.UserTest do
use GraphqlUsersApi.DataCase, async: true
alias GraphqlUsersApiWeb.Schema
alias GraphqlUsersApi.Accounts


@create_user_doc """
mutation createUser($name: String!, $email: String!, $preferences: PreferencesFilter!)
{
  createUser(name: $name , email: $email, preferences: $preferences)
  {
    id
    name
  }
}

"""
#IS THIS A USELESS CREATE USER TEST?
describe "@createUser" do
  test "adds user to database" do
    assert {:ok, %{data: data}} = Absinthe.run(@create_user_doc, Schema,
        variables: %{
          "name" => "test12",
          "email" => "test12@gmail.com",
          "preferences" => %{
            "likesEmails" => true,
            "likesFaxes" => false,
            "likesPhoneCalls" => true
          }
        }
      )
  end
end

@update_user_doc """
mutation updateUser($id: ID!, $name: String, $email:String)
{
updateUser(id: $id, name: $name, email: $email){
id
name
email
}
}
"""
describe "@updateUser" do
  test "updates users information --name and email-- by id" do
    assert {:ok, user} = Accounts.create_user(%{name: "Test5", email: "Test5@gmail.com",
        preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})

    updated_name = "Test6"
    updated_email = "test6@gmail.com"
    assert {:ok, %{data: data}} = Absinthe.run(@update_user_doc, Schema,
        variables: %{
        "id" => user.id,
        "name" => updated_name,
        "email" => updated_email
        }
      )
    update_user_res = data["updateUser"]
    assert update_user_res["name"] === updated_name
    assert update_user_res["email"] === updated_email
  end


end

@update_user_doc_preferences_doc """
mutation updateUserPreferences($id: ID!, $likesEmails: Boolean, $likesFaxes: Boolean, $likesPhoneCalls: Boolean)
{
updateUserPreferences(id: $id, likesEmails: $likesEmails, likesFaxes: $likesFaxes, likesPhoneCalls: $likesPhoneCalls){
id
likesEmails
likesFaxes
likesPhoneCalls
}
}
"""

describe "@updateUserPreferences" do
  test "updates user preferences by id" do
    assert {:ok, user} = Accounts.create_user(%{name: "Test6", email: "Test6@gmail.com",
    preferences: %{likes_emails: true, likes_phone_calls: true, likes_faxes: true}})

    updated_likes_phone_calls_preference = false
    updated_likes_faxes_preference = false
    updated_likes_emails_preference = false

    assert {:ok, %{data: data}} = Absinthe.run(@update_user_doc_preferences_doc, Schema,
        variables: %{
        "id" => user.id,
        "likesPhoneCalls" => updated_likes_phone_calls_preference,
        "likesFaxes" => updated_likes_faxes_preference,
        "likesEmails" => updated_likes_emails_preference
        }
      )
    update_user_preferences_res = data["updateUserPreferences"]
    assert update_user_preferences_res["likesPhoneCalls"] === updated_likes_phone_calls_preference
    assert update_user_preferences_res["likesFaxes"] === updated_likes_faxes_preference
    assert update_user_preferences_res["likesEmails"] === updated_likes_faxes_preference
  end
end

end

defmodule GraphqlUsersApiWeb.Schema.Mutations.UserTest do
use GraphqlUsersApi.DataCase, async: true
alias GraphqlUsersApiWeb.Schema

import GraphqlUsersApi.Support.SetupTasks, only: [setup_user: 1]


setup [:setup_user]
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
#almost certainly an unneccessary test
describe "@createUser" do
  test "adds user to database" do
    test_name = "test12"
    assert {:ok, %{data: data}} = Absinthe.run(@create_user_doc, Schema,
        variables: %{
          "name" => test_name,
          "email" => "test12@gmail.com",
          "preferences" => %{
            "likesEmails" => true,
            "likesFaxes" => false,
            "likesPhoneCalls" => true
          }
        }
      )
    assert data["createUser"]["name"] === test_name
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
  test "updates users information --name and email-- by id", context do
    user = context.user
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
mutation updateUserPreferences($userId: ID!, $likesEmails: Boolean, $likesFaxes: Boolean, $likesPhoneCalls: Boolean)
{
updateUserPreferences(userId: $userId, likesEmails: $likesEmails, likesFaxes: $likesFaxes, likesPhoneCalls: $likesPhoneCalls){
userId
likesEmails
likesFaxes
likesPhoneCalls
}
}
"""

describe "@updateUserPreferences" do
  test "updates user preferences by user id", context do
    user = context.user
    updated_preferences = %{
      "userId" => user.id,
      "likesPhoneCalls" => false,
      "likesFaxes" => false,
      "likesEmails" => false
      }
    assert {:ok, %{data: data}} = Absinthe.run(@update_user_doc_preferences_doc, Schema,
        variables: updated_preferences)
    update_user_preferences_res = data["updateUserPreferences"]
    assert update_user_preferences_res["likesPhoneCalls"] === updated_preferences["likesPhoneCalls"]
    assert update_user_preferences_res["likesFaxes"] === updated_preferences["likesFaxes"]
    assert update_user_preferences_res["likesEmails"] === updated_preferences["likesEmails"]
  end
end

end

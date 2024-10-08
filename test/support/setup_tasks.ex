defmodule GraphqlUsersApi.Support.SetupTasks do
alias GraphqlUsersApi.Accounts

@num_dummy_users 5
@length_of_username 10
def setup_users(_context) do
  users = Enum.map(1..@num_dummy_users, fn _x -> {:ok, user} = add_random_user_to_repo()
  user
end)
  %{users: users}
end

def setup_user(_context) do
  {:ok, user} = add_random_user_to_repo()
  %{user: user}
end

defp add_random_user_to_repo do
  random_name = create_random_n_digit_string(@length_of_username)
  random_email = random_name <> "@testmail.com"
  Accounts.create_user(%{name: random_name, email: random_email,
  preferences: %{likes_emails: rand_bool(), likes_phone_calls: rand_bool(), likes_faxes: rand_bool()}})
end

defp create_random_n_digit_string(n) do
  for _ <- 1..n, into: "", do: <<Enum.random(~c'0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')>>
end

defp rand_bool do
  Enum.random([true, false])
end

end

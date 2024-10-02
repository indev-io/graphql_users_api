defmodule GraphqlUsersApi.Processes.ResolverHitTrackerTest do
  alias GraphqlUsersApi.Processes.ResolverHitTracker
  use ExUnit.Case, async: true

  setup do
    ResolverHitTracker.start_link(name: __MODULE__, state: %{"users" => 1})
    :ok
  end

  describe "&value/2" do
      test "returns value of key if key exists in dictionary" do
      assert ResolverHitTracker.value(__MODULE__, "users") === 1
    end
      test "returns 0 if key doesn't exist in ditionary" do
      assert ResolverHitTracker.value(__MODULE__, "resolverHits") === 0
    end
  end

  describe "&increment/2" do
    test "increments value of key/value pair by 1 if key exists" do
      ResolverHitTracker.increment(__MODULE__, "users")
      assert ResolverHitTracker.value(__MODULE__, "users") === 2
    end
    test "sets value of key/value pair to 1 if key does not exist" do
      ResolverHitTracker.increment(__MODULE__, "resolverHits")
      assert ResolverHitTracker.value(__MODULE__, "resolverHits") === 1
  end
end

end

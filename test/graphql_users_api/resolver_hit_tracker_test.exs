defmodule GraphqlUsersApi.ResolverHitTrackerTest do
  alias GraphqlUsersApi.ResolverHitTracker
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = ResolverHitTracker.start_link(name: nil, state: %{"users" => 1})
    %{pid: pid}
  end

  describe "&value/2" do
    test "returns value of key if key exists in dictionary", %{pid: pid} do
      assert ResolverHitTracker.value(pid, "users") === 1
    end

    test "returns 0 if key doesn't exist in ditionary", %{pid: pid} do
      assert ResolverHitTracker.value(pid, "resolverHits") === 0
    end
  end

  describe "&increment/2" do
    test "increments value of key/value pair by 1 if key exists", %{pid: pid} do
      ResolverHitTracker.increment(pid, "users")
      assert ResolverHitTracker.value(pid, "users") === 2
    end

    test "sets value of key/value pair to 1 if key does not exist", %{pid: pid} do
      ResolverHitTracker.increment(pid, "resolverHits")
      assert ResolverHitTracker.value(pid, "resolverHits") === 1
    end
  end
end

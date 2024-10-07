defmodule GraphqlUsersApi.Repo.Migrations.DropTables do
  use Ecto.Migration

  def change do
    drop table(:users)
    drop table(:preferences)
  end
end

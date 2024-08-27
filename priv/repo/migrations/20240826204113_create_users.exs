defmodule GraphqlUsersApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :text
      add :email, :text
      add :preferences_id, references(:preferences, on_delete: :delete_all)
    end
  end
end

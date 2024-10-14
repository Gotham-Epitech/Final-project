defmodule Backend.Repo.Migrations.AddDefaultValueToUserRole do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :role_id
      add :role_id, references(:teams, on_delete: :delete_all), default: 1
    end
  end
end

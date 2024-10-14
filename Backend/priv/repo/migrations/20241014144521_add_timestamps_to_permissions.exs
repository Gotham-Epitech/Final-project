defmodule Backend.Repo.Migrations.AddTimestampsToPermissions do
  use Ecto.Migration

  def change do
    alter table(:permissions) do
      timestamps()
    end
  end
end

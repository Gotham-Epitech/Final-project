defmodule Backend.Repo.Migrations.ReworkRoles do
  use Ecto.Migration

  def change do
    drop table(:rolespermissions)

    create table(:permissions) do
      add :type, :string
    end

    alter table(:roles) do
      add :permission_id, references(:permissions, on_delete: :nothing)
    end
  end
end

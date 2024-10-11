defmodule Backend.Repo.Migrations.CreateSchemas do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      timestamps()
    end

    create table(:clocks) do
      add :time, :string
      add :status, :string
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end

    create table(:workingtimes) do
      add :start, :string
      add :end, :string
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end
  end
end

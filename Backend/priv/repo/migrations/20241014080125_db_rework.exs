defmodule Backend.Repo.Migrations.DbRework do
  use Ecto.Migration

  def change do
    # 1. Create roles table first
    create table(:roles) do
      add :name, :string
      add :description, :text
      timestamps()
    end

    # 2. Create teams table
    create table(:teams) do
      add :name, :string
      add :description, :text
      add :manager_id, references(:users, on_delete: :delete_all)
      timestamps()
    end

    # 3. Create rolespermissions table
    create table(:rolespermissions) do
      add :permission, :string
      add :role_id, references(:roles, on_delete: :delete_all)
      timestamps()
    end

    # 4. Create timeoffrequests table
    create table(:timeoffrequests) do
      add :start_date, :date
      add :end_date, :date
      add :status, :string  # Changed from :enum to :string
      add :requested_at, :utc_datetime
      add :approved_at, :utc_datetime
      add :approved_by, references(:users, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end

    # 5. Create auditlogs table
    create table(:auditlogs) do
      add :action, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end

    # 6. Create notifications table
    create table(:notifications) do
      add :type, :string  # Changed from :enum to :string
      add :message, :text
      add :is_read, :boolean, default: false
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end

    # 7. Create timelogs table
    create table(:timelogs) do
      add :date, :date
      add :arrival_time, :time
      add :departure_time, :time
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end

    # 8. Alter users table to add new fields and references
    alter table(:users) do
      add :firstname, :string
      add :lastname, :string
      add :password_hash, :string
      add :contact_number, :string
      add :role_id, references(:roles, on_delete: :delete_all)
      add :team_id, references(:teams, on_delete: :delete_all)
    end

    # 9. Alter workingtimes table
    alter table(:workingtimes) do
      remove :start
      remove :end
      add :date, :date
      add :arrival_time, :time
      add :departure_time, :time
    end
  end
end

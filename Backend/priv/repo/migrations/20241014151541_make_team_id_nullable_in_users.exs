defmodule Backend.Repo.Migrations.MakeTeamIdNullableInUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :team_id
      add :team_id, references(:teams, on_delete: :delete_all), null: true, default: nil
    end
  end
end

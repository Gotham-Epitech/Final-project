defmodule Backend.Repo.Migrations.AddDefaultValueToUserTeam do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :team_id, :integer, default: 1
      modify :role_id, :integer, default: 1
    end
  end
end

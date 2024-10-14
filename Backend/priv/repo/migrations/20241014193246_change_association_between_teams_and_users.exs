defmodule Backend.Repo.Migrations.ChangeAssociationBetweenTeamsAndUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :manager_id, references(:users, on_delete: :nothing), null: true, default: nil
    end
  end
end

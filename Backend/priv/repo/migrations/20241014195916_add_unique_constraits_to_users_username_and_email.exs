defmodule Backend.Repo.Migrations.AddUniqueConstraitsToUsersUsernameAndEmail do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end

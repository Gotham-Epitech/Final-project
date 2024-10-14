defmodule Backend.Repo.Migrations.AddUniqueIndexToPermissionsType do
  use Ecto.Migration

  def change do
    # Ensure the `type` column is unique
    create unique_index(:permissions, [:type])
  end
end

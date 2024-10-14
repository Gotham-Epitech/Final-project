defmodule Backend.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :description, :string

    # Associations
    has_many :roles_permissions, Backend.RolesPermission, foreign_key: :role_id
    has_many :users, Backend.User

    # Timestamps
    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> validate_length(:name, min: 1, max: 100)
    |> unique_constraint(:name)
  end
end

defmodule Backend.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :description, :string

    # Associations
    belongs_to :permission, Backend.Permission, foreign_key: :permission_id
    has_many :users, Backend.User

    # Timestamps
    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description, :permission_id])
    |> validate_required([:name, :permission_id])
    |> validate_length(:name, min: 1, max: 100)
    |> unique_constraint(:name)
  end
end

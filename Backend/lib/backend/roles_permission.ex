defmodule Backend.RolesPermission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rolespermissions" do
    field :permission, :string

    # Associations
    belongs_to :role, Backend.Role

    # Timestamps
    timestamps()
  end

  @doc false
  def changeset(roles_permission, attrs) do
    roles_permission
    |> cast(attrs, [:permission, :role_id])
    |> validate_required([:permission, :role_id])
    |> validate_length(:permission, min: 1, max: 100)
    |> assoc_constraint(:role)
    |> unique_constraint(:permission, name: :rolespermissions_role_id_permission_index) # Adjust index name as per your DB
  end
end

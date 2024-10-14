defmodule Backend.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field :type, :string

    # Associations
    has_many :roles, Backend.Role

    # Timestamps
    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:type])
    |> validate_required([:type])
    |> validate_length(:type, min: 1, max: 100)
    |> unique_constraint(:type)
  end
end

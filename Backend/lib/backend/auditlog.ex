defmodule Backend.Auditlog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auditlogs" do
    field :action, :string
    field :description, :string

    # Associations
    belongs_to :user, Backend.User

    # Timestamps
    timestamps()
  end

  @doc false
  def changeset(auditlog, attrs) do
    auditlog
    |> cast(attrs, [:action, :description, :user_id])
    |> validate_required([:action, :description, :user_id])
    |> validate_length(:action, min: 1, max: 100)
    |> assoc_constraint(:user)
  end
end

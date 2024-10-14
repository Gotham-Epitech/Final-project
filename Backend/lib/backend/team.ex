defmodule Backend.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :description, :string

    # Associations
    belongs_to :manager, Backend.User, foreign_key: :manager_id

    # Timestamps
    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :description, :manager_id])
    |> validate_required([:name, :manager_id])
    |> validate_length(:name, min: 1, max: 100)
    |> assoc_constraint(:manager)
  end
end

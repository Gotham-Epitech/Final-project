defmodule Backend.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :time, :status, :user_id]}

  schema "clocks" do
    field :time, :naive_datetime
    field :status, :boolean

    belongs_to :user, Backend.User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:time, :status, :user_id])
    |> validate_inclusion(:status, [true, false], message: "status must be a boolean")
    |> foreign_key_constraint(:user_id)
  end
end

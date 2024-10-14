defmodule Backend.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :type, Ecto.Enum, values: [:info, :warning, :error]
    field :message, :string
    field :is_read, :boolean, default: false

    # Associations
    belongs_to :user, Backend.User

    # Timestamps
    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:type, :message, :is_read, :user_id])
    |> validate_required([:type, :message, :user_id])
    |> validate_inclusion(:type, [:info, :warning, :error])
    |> validate_length(:message, min: 1)
    |> assoc_constraint(:user)
  end
end

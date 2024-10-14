defmodule Backend.TimeoffRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "timeoffrequests" do
    field :start_date, :date
    field :end_date, :date
    field :status, Ecto.Enum, values: [:pending, :approved, :rejected]
    field :requested_at, :utc_datetime
    field :approved_at, :utc_datetime

    # Associations
    belongs_to :approved_by, Backend.User, foreign_key: :approved_by_id
    belongs_to :user, Backend.User

    # Timestamps
    timestamps()
  end

  @doc false
  def changeset(timeoff_request, attrs) do
    timeoff_request
    |> cast(attrs, [:start_date, :end_date, :status, :requested_at, :approved_at, :approved_by_id, :user_id])
    |> validate_required([:start_date, :end_date, :status, :requested_at, :user_id])
    |> validate_inclusion(:status, [:pending, :approved, :rejected])
    |> validate_date_range(:start_date, :end_date)
    |> assoc_constraint(:approved_by)
    |> assoc_constraint(:user)
  end

  defp validate_date_range(changeset, start_field, end_field) do
    start_date = get_field(changeset, start_field)
    end_date = get_field(changeset, end_field)

    if start_date && end_date && Date.compare(end_date, start_date) == :lt do
      add_error(changeset, end_field, "must be after the start date")
    else
      changeset
    end
  end
end

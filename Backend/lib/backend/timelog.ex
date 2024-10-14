defmodule Backend.Timelog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "timelogs" do
    field :date, :date
    field :arrival_time, :time
    field :departure_time, :time

    # Associations
    belongs_to :user, Backend.User

    # Timestamps
    timestamps()
  end

  @doc false
  def changeset(timelog, attrs) do
    timelog
    |> cast(attrs, [:date, :arrival_time, :departure_time, :user_id])
    |> validate_required([:date, :arrival_time, :departure_time, :user_id])
    |> validate_time_order(:arrival_time, :departure_time)
    |> assoc_constraint(:user)
  end

  defp validate_time_order(changeset, arrival_field, departure_field) do
    arrival_time = get_field(changeset, arrival_field)
    departure_time = get_field(changeset, departure_field)

    if arrival_time && departure_time && Time.compare(departure_time, arrival_time) != :gt do
      add_error(changeset, departure_field, "must be after arrival time")
    else
      changeset
    end
  end
end

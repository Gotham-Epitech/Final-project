defmodule Backend.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :start, :end, :user_id]}

  schema "workingtimes" do
    field :start, :naive_datetime
    field :end, :naive_datetime

    belongs_to :user, Backend.User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:start, :end, :user_id])
    |> validate_required([:start, :end, :user_id])
    |> validate_format(:start, ~r/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/, message: "must be in the format YYYY-MM-DD HH:mm:ss")
    |> validate_format(:end, ~r/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/, message: "must be in the format YYYY-MM-DD HH:mm:ss")
    |> validate_timings()
    |> foreign_key_constraint(:user_id)
  end

  defp validate_timings(changeset) do
    case {get_field(changeset, :start), get_field(changeset, :end)} do
      {nil, _} -> changeset
      {_, nil} -> changeset
      {start_time, end_time} when end_time < start_time ->
        add_error(changeset, :end, "must be after the start time")
      _ -> changeset
    end
  end
end

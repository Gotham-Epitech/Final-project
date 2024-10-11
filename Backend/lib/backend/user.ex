defmodule Backend.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.Repo

  @derive {Jason.Encoder, only: [:id, :username, :email]}

  schema "users" do
    field :username, :string
    field :email, :string

    has_many :clock, Backend.Clock
    has_many :workingtime, Backend.Workingtime

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/, message: "must be a valid email format")
    |> validate_length(:username, min: 1, message: "username can't be empty")
    |> unique_username_and_email(user)
  end

  defp unique_username_and_email(changeset, user) do
    changeset
    |> check_unique_username(user)
    |> check_unique_email(user)
  end

  defp check_unique_username(changeset, user) do
    if get_change(changeset, :username) do
      # Validate uniqueness only if the username is changing
      case Repo.get_by(__MODULE__, username: get_field(changeset, :username)) do
        nil -> changeset
        ^user -> changeset  # Allow if the username belongs to the same user
        _ -> add_error(changeset, :username, "has already been taken")
      end
    else
      changeset
    end
  end

  defp check_unique_email(changeset, user) do
    if get_change(changeset, :email) do
      # Validate uniqueness only if the email is changing
      case Repo.get_by(__MODULE__, email: get_field(changeset, :email)) do
        nil -> changeset
        ^user -> changeset  # Allow if the email belongs to the same user
        _ -> add_error(changeset, :email, "has already been taken")
      end
    else
      changeset
    end
  end
end

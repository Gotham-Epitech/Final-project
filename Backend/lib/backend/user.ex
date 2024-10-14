defmodule Backend.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Backend.Repo

  @derive {Jason.Encoder, only: [:id, :username, :email, :firstname, :lastname, :contact_number]}

  schema "users" do
    # Existing Fields
    field :username, :string
    field :email, :string

    # New Fields
    field :firstname, :string
    field :lastname, :string
    field :password_hash, :string
    field :contact_number, :string

    # Virtual Field for Password
    field :password, :string, virtual: true

    # Associations
    has_many :clock, Backend.Clock
    has_many :workingtime, Backend.Workingtime

    # New Associations
    belongs_to :role, Backend.Role
    belongs_to :team, Backend.Team

    # Additional Associations
    has_many :roles_permissions, Backend.RolesPermission, foreign_key: :role_id
    has_many :timeoff_requests, Backend.TimeoffRequest, foreign_key: :user_id
    has_many :approved_timeoff_requests, Backend.TimeoffRequest, foreign_key: :approved_by_id
    has_many :audit_logs, Backend.Auditlog, foreign_key: :user_id
    has_many :notifications, Backend.Notification, foreign_key: :user_id
    has_many :time_logs, Backend.Timelog, foreign_key: :user_id
    has_many :managed_teams, Backend.Team, foreign_key: :manager_id

    # Timestamps
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :username,
      :email,
      :firstname,
      :lastname,
      :password,
      :contact_number,
      :role_id,
      :team_id
    ])
    |> validate_required([
      :username,
      :email,
      :firstname,
      :lastname,
      :contact_number,
      :role_id,
      :team_id
    ])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/, message: "must be a valid email format")
    |> validate_length(:username, min: 1, message: "username can't be empty")
    |> validate_length(:firstname, min: 1, max: 50)
    |> validate_length(:lastname, min: 1, max: 50)
    |> validate_format(:contact_number, ~r/^\+?[1-9]\d{1,14}$/, message: "must be a valid contact number")
    |> unique_username_and_email(user)
    |> put_password_hash()
    |> assoc_constraint(:role)
    |> assoc_constraint(:team)
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

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end
end

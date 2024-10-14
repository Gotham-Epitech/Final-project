# priv/repo/seeds.exs

alias Backend.Repo
alias Backend.Permission
alias Backend.Role
alias Backend.User
import Ecto.Query

# Insert Permissions
permissions = [
  %{type: "restricted"},
  %{type: "user"},
  %{type: "manager"},
  %{type: "generalmanager"},
  %{type: "admin"}
]

Enum.each(permissions, fn perm_attrs ->
  Repo.insert!(
    Permission.changeset(%Permission{}, perm_attrs),
    on_conflict: :nothing,
    conflict_target: :type
  )
end)

# Fetch all permissions and create a map for easy lookup
permissions_map =
  Repo.all(Permission)
  |> Enum.map(fn perm -> {perm.type, perm.id} end)
  |> Enum.into(%{})

# Insert Roles
roles = [
  %{name: "visitor", description: "salut", permission_id: permissions_map["restricted"]},
  %{name: "janitor", description: "cleaning employee", permission_id: permissions_map["user"]},
  %{name: "hr", description: "hr", permission_id: permissions_map["manager"]},
  %{name: "ceo", description: "big boss", permission_id: permissions_map["generalmanager"]},
  %{name: "admin", description: "Administrator", permission_id: permissions_map["admin"]}
]

Enum.each(roles, fn role_attrs ->
  Repo.insert!(
    Role.changeset(%Role{}, role_attrs),
    on_conflict: :nothing,
    conflict_target: :name
  )
end)

# Fetch roles to get their IDs
roles_map =
  Repo.all(Role)
  |> Enum.map(fn role -> {role.name, role.id} end)
  |> Enum.into(%{})

# Define Users
users = [
  %{
    username: "visitor",
    email: "visitor@visitor.com",
    password: "visitor",
    firstname: "visitor",
    lastname: "visitor",
    contact_number: "1234567890",
    role_name: "visitor"
  },
  %{
    username: "janitor",
    email: "janitor@janitor.com",
    password: "janitor",
    firstname: "janitor",
    lastname: "janitor",
    contact_number: "1234567890",
    role_name: "janitor"
  },
  %{
    username: "hr",
    email: "hr@hr.com",
    password: "hr",
    firstname: "hr",
    lastname: "hr",
    contact_number: "1234567890",
    role_name: "hr"
  },
  %{
    username: "ceo",
    email: "ceo@ceo.com",
    password: "ceo",
    firstname: "ceo",
    lastname: "ceo",
    contact_number: "1234567890",
    role_name: "ceo"
  },
  %{
    username: "admin",
    email: "admin@admin.com",
    password: "admin",
    firstname: "admin",
    lastname: "admin",
    contact_number: "1234567890",
    role_name: "admin"
  }
]

# Insert Users One by One with Existence Checks
Enum.each(users, fn user_attrs ->
  # Log the current user being processed
  IO.puts("Processing user: #{user_attrs.username}")

  # Check if a user with the same username or email already exists
  existing_user =
    Repo.one(
      from u in User,
        where: u.username == ^user_attrs.username or u.email == ^user_attrs.email,
        select: u
    )

  if existing_user do
    IO.puts("User #{user_attrs.username} or email #{user_attrs.email} already exists. Skipping insertion.")
  else
    role_id = Map.get(roles_map, user_attrs.role_name)

    user_changeset =
      User.changeset(%User{}, %{
        username: user_attrs.username,
        email: user_attrs.email,
        password: user_attrs.password,
        firstname: user_attrs.firstname,
        lastname: user_attrs.lastname,
        contact_number: user_attrs.contact_number,
        role_id: role_id,
        team_id: nil  # Assuming users are not assigned to a team initially
      })

    case Repo.insert(user_changeset) do
      {:ok, _user} ->
        IO.puts("Inserted user: #{user_attrs.username}")

      {:error, changeset} ->
        IO.puts("Failed to insert user: #{user_attrs.username}. Errors: #{inspect(changeset.errors)}")
    end
  end
end)

IO.puts("Seeding completed successfully.")

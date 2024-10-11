defmodule BackendWeb.UserController do
  use BackendWeb, :controller
  alias Backend.{Repo, User}
  import Ecto.Query, only: [from: 2]

  def index(conn, params) do
    query = User |> build_user_query(params)
    users = Repo.all(query)
    json(conn, users)
  end

  defp build_user_query(query, %{"username" => username, "email" => email}) do
    from u in query,
      where: u.username == ^username and u.email == ^email
  end

  defp build_user_query(query, %{"username" => username}) do
    from u in query,
      where: u.username == ^username
  end

  defp build_user_query(query, %{"email" => email}) do
    from u in query,
      where: u.email == ^email
  end

  defp build_user_query(query, _params) do
    query
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    json(conn, user)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        json(conn, user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end

  # Helper function to format changeset errors into a JSON-friendly structure
  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

end

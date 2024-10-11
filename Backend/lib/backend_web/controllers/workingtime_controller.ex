defmodule BackendWeb.WorkingtimeController do
  use BackendWeb, :controller
  alias Backend.{Repo, Workingtime}
  import Ecto.Query

  # Fetch all working times for a specific user, with optional query parameters for start and end.
  def index(conn, %{"user_id" => user_id}) do
    query =
      from(w in Workingtime,
        where: w.user_id == ^user_id,
        select: w
      )

    workingtimes =
      case conn.params do
        %{"start" => start, "end" => end_time} ->
          from(w in query, where: w.start >= ^start and w.end <= ^end_time)
          |> Repo.all()

        _ ->
          Repo.all(query)
      end

    if workingtimes == [] do
      conn
      |> put_status(:not_found)
      |> json(%{error: "No workingtimes found for this user"})
    else
      json(conn, workingtimes)
    end
  end

  # Fetch a specific working time for a user
  def show(conn, %{"user_id" => user_id, "id" => id}) do
    case Repo.get_by(Workingtime, id: id, user_id: user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "error 404: workingtime not found"})
      workingtime ->
        json(conn, workingtime)
    end
  end

  # Create a new working time for a specific user
  def create(conn, %{"user_id" => user_id, "workingtime" => workingtime_params}) do
    changeset = Workingtime.changeset(%Workingtime{user_id: user_id}, workingtime_params)

    case Repo.insert(changeset) do
      {:ok, workingtime} ->
        conn
        |> put_status(:created)
        |> json(workingtime)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "code 400: workingtime creation failed", details: changeset})
    end
  end

  # Update a specific working time for a user
  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Repo.get!(Workingtime, id)

    if workingtime.user_id == conn.params["user_id"] do
      changeset = Workingtime.changeset(workingtime, workingtime_params)

      case Repo.update(changeset) do
        {:ok, workingtime} ->
          json(conn, workingtime)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(changeset)
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "You do not have permission to update this working time"})
    end
  end

  # Delete a specific working time
  def delete(conn, %{"id" => id}) do
    workingtime = Repo.get!(Workingtime, id)

    if workingtime.user_id == conn.params["user_id"] do
      Repo.delete!(workingtime)
      send_resp(conn, :no_content, "")
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "You do not have permission to delete this working time"})
    end
  end
end

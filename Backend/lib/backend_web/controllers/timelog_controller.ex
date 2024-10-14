defmodule BackendWeb.TimelogController do
  use BackendWeb, :controller
  alias Backend.{Repo, Timelog}
  import Ecto.Query

  # Fetch all timelogs for a specific user
  def index(conn, %{"user_id" => user_id}) do
    timelogs = Repo.all(from(c in Timelog, where: c.user_id == ^user_id))

    if timelogs == [] do
      conn
      |> put_status(:not_found)
      |> json(%{error: "No timelogs found for this user"})
    else
      json(conn, timelogs)
    end
  end

  # Fetch a specific timelog for a user
  def show(conn, %{"user_id" => user_id, "id" => id}) do
    case Repo.get_by(Timelog, id: id, user_id: user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "error 404: timelog not found"})
      timelog ->
        json(conn, timelog)
    end
  end

  # Create a new timelog for a specific user
  def create(conn, %{"user_id" => user_id, "timelog" => timelog_params}) do
    changeset = Timelog.changeset(%Timelog{user_id: user_id}, timelog_params)

    case Repo.insert(changeset) do
      {:ok, timelog} ->
        conn
        |> put_status(:created)
        |> json(timelog)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "code 400: timelog creation failed", details: changeset})
    end
  end

  # Update a specific timelog for a user
  def update(conn, %{"id" => id, "timelog" => timelog_params}) do
    timelog = Repo.get!(Timelog, id)

    if timelog.user_id == conn.params["user_id"] do
      changeset = Timelog.changeset(timelog, timelog_params)

      case Repo.update(changeset) do
        {:ok, timelog} ->
          json(conn, timelog)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(changeset)
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "You do not have permission to update this timelog"})
    end
  end

  # Delete a specific timelog
  def delete(conn, %{"id" => id}) do
    timelog = Repo.get!(Timelog, id)

    if timelog.user_id == conn.params["user_id"] do
      Repo.delete!(timelog)
      send_resp(conn, :no_content, "")
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "You do not have permission to delete this timelog"})
    end
  end
end

defmodule BackendWeb.ClockController do
  use BackendWeb, :controller
  alias Backend.{Repo, Clock}
  import Ecto.Query

  # Fetch all clocks for a specific user
  def index(conn, %{"user_id" => user_id}) do
    clocks = Repo.all(from(c in Clock, where: c.user_id == ^user_id))

    if clocks == [] do
      conn
      |> put_status(:not_found)
      |> json(%{error: "No clocks found for this user"})
    else
      json(conn, clocks)
    end
  end

  # Fetch a specific clock for a user
  def show(conn, %{"user_id" => user_id, "id" => id}) do
    case Repo.get_by(Clock, id: id, user_id: user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "error 404: clock not found"})
      clock ->
        json(conn, clock)
    end
  end

  # Create a new clock for a specific user
  def create(conn, %{"user_id" => user_id, "clock" => clock_params}) do
    changeset = Clock.changeset(%Clock{user_id: user_id}, clock_params)

    case Repo.insert(changeset) do
      {:ok, clock} ->
        conn
        |> put_status(:created)
        |> json(clock)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "code 400: clock creation failed", details: changeset})
    end
  end

  # Update a specific clock for a user
  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Repo.get!(Clock, id)

    if clock.user_id == conn.params["user_id"] do
      changeset = Clock.changeset(clock, clock_params)

      case Repo.update(changeset) do
        {:ok, clock} ->
          json(conn, clock)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(changeset)
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "You do not have permission to update this clock"})
    end
  end

  # Delete a specific clock
  def delete(conn, %{"id" => id}) do
    clock = Repo.get!(Clock, id)

    if clock.user_id == conn.params["user_id"] do
      Repo.delete!(clock)
      send_resp(conn, :no_content, "")
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "You do not have permission to delete this clock"})
    end
  end
end

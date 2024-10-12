defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api

    # User CRUD Routes
    get "/users", UserController, :index  # Fetch users based on query parameters
    get "/users/:id", UserController, :show  # Get a specific user by ID
    post "/users", UserController, :create  # Create a new user
    put "/users/:id", UserController, :update  # Update a specific user
    delete "/users/:id", UserController, :delete  # Delete a specific user

    # Workingtime CRUD Routes
    get "/workingtime/:user_id", WorkingtimeController, :index  # Get all working times for a user
    get "/workingtime/:user_id/:id", WorkingtimeController, :show  # Get a specific working time
    post "/workingtime/:user_id", WorkingtimeController, :create  # Create a working time for a user
    put "/workingtime/:id", WorkingtimeController, :update  # Update a specific working time
    delete "/workingtime/:id", WorkingtimeController, :delete  # Delete a specific working time

    # Clock CRUD Routes
    get "/clocks/:user_id", ClockController, :index  # Get all clocks for a user
    post "/clocks/:user_id", ClockController, :create  # Create a clock for a user
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:backend, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BackendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

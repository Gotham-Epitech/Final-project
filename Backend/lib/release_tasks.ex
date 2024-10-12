defmodule Backend.ReleaseTasks do
  @moduledoc """
  Provides tasks to be run during release, such as running migrations.
  """

  @app :backend

  def migrate do
    # Load the application code
    Application.load(@app)

    # Start the necessary applications
    for app <- [:crypto, :ssl, :postgrex, :ecto_sql] do
      Application.ensure_all_started(app)
    end

    # Run migrations for each repo
    for repo <- repos() do
      IO.puts("Running migrations for #{inspect(repo)}")
      Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end

    IO.puts("Migrations ran successfully!")
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end
end

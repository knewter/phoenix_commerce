ExUnit.start

Mix.Task.run "ecto.drop", ~w(-r PhoenixCommerce.Repo --quiet)
Mix.Task.run "ecto.create", ~w(-r PhoenixCommerce.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PhoenixCommerce.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PhoenixCommerce.Repo)

ExUnit.configure(exclude: [external: true])

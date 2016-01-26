defmodule PhoenixCommerce.Repo.Migrations.CreateCart do
  use Ecto.Migration

  def change do
    create table(:carts) do
      add :uuid, :uuid

      timestamps
    end

  end
end

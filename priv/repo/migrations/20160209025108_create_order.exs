defmodule PhoenixCommerce.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      timestamps
    end

    alter table(:line_items) do
      add :order_id, references(:orders)
    end
  end
end

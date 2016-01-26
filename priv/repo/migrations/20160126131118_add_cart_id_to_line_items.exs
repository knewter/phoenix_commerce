defmodule PhoenixCommerce.Repo.Migrations.AddCartIdToLineItems do
  use Ecto.Migration

  def change do
    alter table(:line_items) do
      add :cart_id, references(:carts)
    end
  end
end

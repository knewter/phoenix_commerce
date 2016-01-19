defmodule PhoenixCommerce.Repo.Migrations.AddImageToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :image, :string
    end
  end
end

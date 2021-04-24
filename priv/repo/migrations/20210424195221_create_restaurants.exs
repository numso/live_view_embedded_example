defmodule LiveViewEmbeddedExample.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :location, :string
      add :rating, :integer
      add :menu_items, {:array, :map}

      timestamps()
    end

  end
end

defmodule LiveViewEmbeddedExample.Dining.Restaurant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "restaurants" do
    field :location, :string
    field :menu_items, {:array, :map}
    field :name, :string
    field :rating, :integer

    timestamps()
  end

  @doc false
  def changeset(restaurant, attrs) do
    restaurant
    |> cast(attrs, [:name, :location, :rating, :menu_items])
    |> validate_required([:name, :location, :rating, :menu_items])
  end
end

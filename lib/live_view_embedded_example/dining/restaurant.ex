defmodule LiveViewEmbeddedExample.Dining.Restaurant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "restaurants" do
    field :location, :string

    embeds_many :menu_items, MenuItem, on_replace: :delete do
      field :name, :string
      field :price, :string
      field :type, Ecto.Enum, values: [:appetizer, :drink, :dessert, :soup, :salad, :entree]
    end

    field :name, :string
    field :rating, :integer

    timestamps()
  end

  @doc false
  def changeset(restaurant, attrs) do
    restaurant
    |> cast(attrs, [:name, :location, :rating])
    |> cast_embed(:menu_items, with: &menu_item_changeset/2)
    |> validate_required([:name, :location, :rating])
  end

  @doc false
  def menu_item_changeset(menu_item, attrs) do
    menu_item
    |> Map.put(:id, menu_item.id || attrs["id"])
    |> cast(attrs, [:name, :price, :type])
    |> validate_required([:name, :price, :type])
  end
end

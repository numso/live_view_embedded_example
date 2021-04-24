defmodule LiveViewEmbeddedExample.DiningTest do
  use LiveViewEmbeddedExample.DataCase

  alias LiveViewEmbeddedExample.Dining

  describe "restaurants" do
    alias LiveViewEmbeddedExample.Dining.Restaurant

    @valid_attrs %{location: "some location", menu_items: [], name: "some name", rating: 42}
    @update_attrs %{location: "some updated location", menu_items: [], name: "some updated name", rating: 43}
    @invalid_attrs %{location: nil, menu_items: nil, name: nil, rating: nil}

    def restaurant_fixture(attrs \\ %{}) do
      {:ok, restaurant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Dining.create_restaurant()

      restaurant
    end

    test "list_restaurants/0 returns all restaurants" do
      restaurant = restaurant_fixture()
      assert Dining.list_restaurants() == [restaurant]
    end

    test "get_restaurant!/1 returns the restaurant with given id" do
      restaurant = restaurant_fixture()
      assert Dining.get_restaurant!(restaurant.id) == restaurant
    end

    test "create_restaurant/1 with valid data creates a restaurant" do
      assert {:ok, %Restaurant{} = restaurant} = Dining.create_restaurant(@valid_attrs)
      assert restaurant.location == "some location"
      assert restaurant.menu_items == []
      assert restaurant.name == "some name"
      assert restaurant.rating == 42
    end

    test "create_restaurant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dining.create_restaurant(@invalid_attrs)
    end

    test "update_restaurant/2 with valid data updates the restaurant" do
      restaurant = restaurant_fixture()
      assert {:ok, %Restaurant{} = restaurant} = Dining.update_restaurant(restaurant, @update_attrs)
      assert restaurant.location == "some updated location"
      assert restaurant.menu_items == []
      assert restaurant.name == "some updated name"
      assert restaurant.rating == 43
    end

    test "update_restaurant/2 with invalid data returns error changeset" do
      restaurant = restaurant_fixture()
      assert {:error, %Ecto.Changeset{}} = Dining.update_restaurant(restaurant, @invalid_attrs)
      assert restaurant == Dining.get_restaurant!(restaurant.id)
    end

    test "delete_restaurant/1 deletes the restaurant" do
      restaurant = restaurant_fixture()
      assert {:ok, %Restaurant{}} = Dining.delete_restaurant(restaurant)
      assert_raise Ecto.NoResultsError, fn -> Dining.get_restaurant!(restaurant.id) end
    end

    test "change_restaurant/1 returns a restaurant changeset" do
      restaurant = restaurant_fixture()
      assert %Ecto.Changeset{} = Dining.change_restaurant(restaurant)
    end
  end
end

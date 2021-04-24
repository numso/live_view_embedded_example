defmodule LiveViewEmbeddedExampleWeb.RestaurantLiveTest do
  use LiveViewEmbeddedExampleWeb.ConnCase

  import Phoenix.LiveViewTest

  alias LiveViewEmbeddedExample.Dining

  @create_attrs %{location: "some location", menu_items: [], name: "some name", rating: 42}
  @update_attrs %{location: "some updated location", menu_items: [], name: "some updated name", rating: 43}
  @invalid_attrs %{location: nil, menu_items: nil, name: nil, rating: nil}

  defp fixture(:restaurant) do
    {:ok, restaurant} = Dining.create_restaurant(@create_attrs)
    restaurant
  end

  defp create_restaurant(_) do
    restaurant = fixture(:restaurant)
    %{restaurant: restaurant}
  end

  describe "Index" do
    setup [:create_restaurant]

    test "lists all restaurants", %{conn: conn, restaurant: restaurant} do
      {:ok, _index_live, html} = live(conn, Routes.restaurant_index_path(conn, :index))

      assert html =~ "Listing Restaurants"
      assert html =~ restaurant.location
    end

    test "saves new restaurant", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.restaurant_index_path(conn, :index))

      assert index_live |> element("a", "New Restaurant") |> render_click() =~
               "New Restaurant"

      assert_patch(index_live, Routes.restaurant_index_path(conn, :new))

      assert index_live
             |> form("#restaurant-form", restaurant: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#restaurant-form", restaurant: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.restaurant_index_path(conn, :index))

      assert html =~ "Restaurant created successfully"
      assert html =~ "some location"
    end

    test "updates restaurant in listing", %{conn: conn, restaurant: restaurant} do
      {:ok, index_live, _html} = live(conn, Routes.restaurant_index_path(conn, :index))

      assert index_live |> element("#restaurant-#{restaurant.id} a", "Edit") |> render_click() =~
               "Edit Restaurant"

      assert_patch(index_live, Routes.restaurant_index_path(conn, :edit, restaurant))

      assert index_live
             |> form("#restaurant-form", restaurant: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#restaurant-form", restaurant: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.restaurant_index_path(conn, :index))

      assert html =~ "Restaurant updated successfully"
      assert html =~ "some updated location"
    end

    test "deletes restaurant in listing", %{conn: conn, restaurant: restaurant} do
      {:ok, index_live, _html} = live(conn, Routes.restaurant_index_path(conn, :index))

      assert index_live |> element("#restaurant-#{restaurant.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#restaurant-#{restaurant.id}")
    end
  end

  describe "Show" do
    setup [:create_restaurant]

    test "displays restaurant", %{conn: conn, restaurant: restaurant} do
      {:ok, _show_live, html} = live(conn, Routes.restaurant_show_path(conn, :show, restaurant))

      assert html =~ "Show Restaurant"
      assert html =~ restaurant.location
    end

    test "updates restaurant within modal", %{conn: conn, restaurant: restaurant} do
      {:ok, show_live, _html} = live(conn, Routes.restaurant_show_path(conn, :show, restaurant))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Restaurant"

      assert_patch(show_live, Routes.restaurant_show_path(conn, :edit, restaurant))

      assert show_live
             |> form("#restaurant-form", restaurant: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#restaurant-form", restaurant: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.restaurant_show_path(conn, :show, restaurant))

      assert html =~ "Restaurant updated successfully"
      assert html =~ "some updated location"
    end
  end
end

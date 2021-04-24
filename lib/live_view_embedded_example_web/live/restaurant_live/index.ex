defmodule LiveViewEmbeddedExampleWeb.RestaurantLive.Index do
  use LiveViewEmbeddedExampleWeb, :live_view

  alias LiveViewEmbeddedExample.Dining
  alias LiveViewEmbeddedExample.Dining.Restaurant

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :restaurants, list_restaurants())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Restaurant")
    |> assign(:restaurant, Dining.get_restaurant!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Restaurant")
    |> assign(:restaurant, %Restaurant{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Restaurants")
    |> assign(:restaurant, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    restaurant = Dining.get_restaurant!(id)
    {:ok, _} = Dining.delete_restaurant(restaurant)

    {:noreply, assign(socket, :restaurants, list_restaurants())}
  end

  defp list_restaurants do
    Dining.list_restaurants()
  end
end

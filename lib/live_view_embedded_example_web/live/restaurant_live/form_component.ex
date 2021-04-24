defmodule LiveViewEmbeddedExampleWeb.RestaurantLive.FormComponent do
  use LiveViewEmbeddedExampleWeb, :live_component

  alias LiveViewEmbeddedExample.Dining
  alias LiveViewEmbeddedExample.Dining.Restaurant.MenuItem

  @impl true
  def update(%{restaurant: restaurant} = assigns, socket) do
    changeset = Dining.change_restaurant(restaurant)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"restaurant" => restaurant_params}, socket) do
    changeset =
      socket.assigns.restaurant
      |> Dining.change_restaurant(restaurant_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"restaurant" => restaurant_params}, socket) do
    save_restaurant(socket, socket.assigns.action, restaurant_params)
  end

  def handle_event("add-menu-item", _, socket) do
    existing = field(socket.assigns.changeset, :menu_items)
    menu_items = existing ++ [Dining.change_menu_item(%MenuItem{id: Ecto.UUID.generate()})]
    changeset = Ecto.Changeset.put_embed(socket.assigns.changeset, :menu_items, menu_items)
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-menu-item", %{"id" => id}, socket) do
    existing = field(socket.assigns.changeset, :menu_items)
    menu_items = existing |> Enum.reject(&(&1.id == id))
    changeset = Ecto.Changeset.put_embed(socket.assigns.changeset, :menu_items, menu_items)
    {:noreply, assign(socket, changeset: changeset)}
  end

  defp save_restaurant(socket, :edit, restaurant_params) do
    case Dining.update_restaurant(socket.assigns.restaurant, restaurant_params) do
      {:ok, _restaurant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Restaurant updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_restaurant(socket, :new, restaurant_params) do
    case Dining.create_restaurant(restaurant_params) do
      {:ok, _restaurant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Restaurant created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp field(changeset, key) do
    Ecto.Changeset.get_field(changeset, key)
  end
end

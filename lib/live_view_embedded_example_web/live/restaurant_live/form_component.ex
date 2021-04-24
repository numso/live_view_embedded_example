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

  def handle_event("add-row", %{"type" => "menu_items"}, socket) do
    add_row(socket, :menu_items, Dining.change_menu_item(%MenuItem{id: Ecto.UUID.generate()}))
  end

  def handle_event("remove-row", %{"type" => "menu_items", "id" => id}, socket) do
    remove_row(socket, :menu_items, id)
  end

  defp add_row(socket, key, new_item) do
    value = field(socket.assigns.changeset, key) ++ [new_item]
    changeset = Ecto.Changeset.put_embed(socket.assigns.changeset, key, value)
    {:noreply, assign(socket, changeset: changeset)}
  end

  defp remove_row(socket, key, id) do
    value = field(socket.assigns.changeset, key) |> Enum.reject(&(&1.id == id))
    changeset = Ecto.Changeset.put_embed(socket.assigns.changeset, key, value)
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

  defp my_table(f, key, myself, children) do
    do_my_table(%{f: f, key: key, myself: myself, children: children})
  end

  defp do_my_table(assigns) do
    ~L"""
    <table>
      <tbody>
        <%= for f <- inputs_for @f, @key do %>
          <tr>
            <%= @children.(f) %>
            <td>
              <%= hidden_input f, :id %>
              <button type="button" phx-target="<%= @myself %>" phx-click="remove-row" phx-value-type="<%= @key %>" phx-value-id="<%= f.data.id %>">Remove</button>
            </td>
          </tr>
        <% end %>
      </tbody>
    </table>
    <button type="button" phx-target="<%= @myself %>" phx-click="add-row" phx-value-type="<%= @key %>">+ Add New Row</button>
    """
  end
end

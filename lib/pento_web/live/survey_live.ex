defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias PentoWeb.DemographicLive
  alias Pento.Survey
  alias Pento.Catalog
  alias PentoWeb.RatingLive

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_demographic
     |> assign_products}
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(
      socket,
      :demographic,
      Survey.get_demographic_by_user(current_user)
    )
  end

  defp assign_products(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :products, list_products(current_user))
  end

  defp list_products(user) do
    Catalog.list_products_with_user_rating(user)
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply,
     socket
     |> handle_demographic_created(demographic)}
  end

  def handle_info(
        {:created_rating, updated_product, product_index},
        socket
      ) do
    {:noreply,
     socket
     |> handle_rating_created(updated_product, product_index)}
  end

  def handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "User info input successfully")
    |> assign(:demographic, demographic)
  end

  def handle_rating_created(
        %{assigns: %{products: products}} = socket,
        updated_product,
        product_index
      ) do
    socket
    |> put_flash(:info, "Rating submitted successfully")
    |> assign(
      :products,
      products
      |> List.replace_at(product_index, updated_product)
    )
  end
end

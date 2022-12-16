defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component
  use PentoWeb, :chart_live

  alias Pento.Catalog
  alias Contex

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_age_group_filter()
     |> assign_products_with_average_ratings()
     |> update_chart()}
  end

  def update_chart(socket) do
    socket
    |> assign_dataset()
    |> assign_chart()
    |> assign_chart_svg()
  end

  def handle_event(
        "age_group_filter",
        %{"age_group_filter" => age_group_filter},
        socket
      ) do
    {:noreply,
     socket
     |> assign_age_group_filter(age_group_filter)
     |> assign_products_with_average_ratings()
     |> update_chart()}
  end

  defp assign_dataset(
         %{
           assigns: %{
             products_with_average_ratings: products_with_average_ratings
           }
         } = socket
       ) do
    socket
    |> assign(
      :dataset,
      make_bar_chart_dataset(products_with_average_ratings)
    )
  end

  defp assign_products_with_average_ratings(
         %{assigns: %{age_group_filter: age_group_filter}} = socket
       ) do
    socket
    |> assign(
      :products_with_average_ratings,
      Catalog.all_products_with_average_ratings(%{age_group_filter: age_group_filter})
    )
  end

  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  defp assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    params = %{
      chart: chart,
      title: "Product Ratings",
      subtitle: "Average user rating per product",
      xlab: "Products",
      ylab: "Stars"
    }

    socket
    |> assign(:chart_svg, render_bar_chart(params))
  end

  defp assign_age_group_filter(socket, filter) do
    socket
    |> assign(:age_group_filter, filter)
  end

  defp assign_age_group_filter(%{assigns: %{age_group_filter: _}} = socket) do
    socket
  end

  defp assign_age_group_filter(socket) do
    socket
    |> assign(:age_group_filter, "All")
  end
end

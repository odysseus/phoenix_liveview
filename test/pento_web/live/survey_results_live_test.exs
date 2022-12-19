defmodule PentoWeb.SurveyResultsLiveTest do
  use PentoWeb.ConnCase
  import Pento.{SurveyFixtures, CatalogFixtures, AccountsFixtures}
  import Phoenix.LiveViewTest

  alias PentoWeb.Admin.SurveyResultsLive
  alias Phoenix.LiveView

  defp visit_page(%{conn: conn}) do
    {:ok, survey_live, html} = live(conn, "/admin-dashboard")

    %{survey_live: survey_live, html: html}
  end

  defp update_socket(socket) do
    {:ok, socket} = SurveyResultsLive.update(%{}, socket)
    socket
  end

  defp assert_assigns_equal(socket, pairs) do
    for {key, val} <- pairs do
      assert socket.assigns[key] == val
    end

    socket
  end

  defp assert_assigns_match(socket, key, matchfn) do
    assert matchfn.(socket.assigns[key])

    socket
  end

  describe "update pipeline" do
    setup [
      :create_product,
      :create_socket,
      :create_user,
      :create_demographic
    ]

    test "generates ratings when no ratings exist", %{socket: socket} do
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)

      assert socket.assigns.products_with_average_ratings ==
               [{"Example Game", 0}]
    end

    test "contains correct ratings when ratings exist",
         %{socket: socket} = context do
      rating = rating_fixture(Map.put(context, :stars, 4))
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)

      assert socket.assigns.products_with_average_ratings ==
               [{"Example Game", rating.stars}]
    end

    test "assigns Contex dataset to :dataset key", %{socket: socket} do
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)

      assert %Contex.Dataset{} = socket.assigns.dataset
    end

    test "assigns Contex chart to :chart key", %{socket: socket} do
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)

      assert %Contex.BarChart{} = socket.assigns.chart
    end

    test "assigns chart SVG to :chart_svg key", %{socket: socket} do
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)

      assert {:safe, [h | _]} = socket.assigns.chart_svg
      assert h =~ ~r/svg/
    end

    test "assigns :age_group_filter when none exists", %{socket: socket} do
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)

      assert socket.assigns.age_group_filter == "All"
    end

    test "doesn't overwrite :age_group_filter if it exists", %{socket: socket} do
      socket
      |> update_socket()
      |> assert_assigns_equal(age_group_filter: "All")
      |> LiveView.assign(age_group_filter: "18 and under")
      |> update_socket()
      |> assert_assigns_equal(age_group_filter: "18 and under")
    end

    test "update pipeline", %{socket: socket} do
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)

      socket
      |> assert_assigns_equal(age_group_filter: "All")
      |> assert_assigns_equal(products_with_average_ratings: [{"Example Game", 0}])
      |> assert_assigns_match(:dataset, &(%Contex.Dataset{} = &1))
      |> assert_assigns_match(:chart, &(%Contex.BarChart{} = &1))
      |> assert_assigns_match(:chart_svg, &({:safe, [<<"<svg">> <> _ | _]} = &1))
    end
  end

  describe "survey results live view" do
    setup [
      :register_and_log_in_user,
      :create_product,
      :create_rating,
      :visit_page
    ]

    test "has the correct title",
         %{survey_live: survey_live, html: html} do
      assert survey_live.module == PentoWeb.Admin.DashboardLive
      assert html =~ "Admin Dashboard"
    end

    test "contains the survey results view",
         %{product: product, html: html} do
      assert html =~ "Survey Results"
      assert html =~ "Product Ratings"
      assert html =~ product.name
    end

    test "default selection is 'All'",
         %{html: html} do
      assert html =~ ~r|<option value="All" selected="selected"|
    end

    test "can change the age group filter",
         %{survey_live: survey_live} do
      html =
        survey_live
        |> element("#age-group-select")
        |> render_change(%{age_group_filter: "50 and up"})

      assert html =~ ~r|<option value="50 and up" selected="selected"|
    end
  end
end

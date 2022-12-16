defmodule PentoWeb.SurveyResultsLiveTest do
  use PentoWeb.ConnCase
  import Phoenix.LiveViewTest

  alias PentoWeb.Admin.SurveyResultsLive
  alias Pento.{Accounts, Survey, Catalog}
  import Pento.{AccountsFixtures, SurveyFixtures, CatalogFixtures}

  describe "Test update" do
    setup [:register_and_log_in_user, :create_product, :create_demographic, :create_socket]

    test "when no ratings exist", %{socket: socket} do
      {:ok, socket} = SurveyResultsLive.update(%{}, socket)

      assert socket.assigns.products_with_average_ratings == [{"Example Game", 0}]
    end
  end
end

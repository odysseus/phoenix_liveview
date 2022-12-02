defmodule Pento.SurveyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Survey` context.
  """

  alias Pento.AccountsFixtures
  alias Pento.CatalogFixtures

  @doc """
  Generate a demographic.
  """
  def demographic_fixture(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()

    {:ok, demographic} =
      attrs
      |> Enum.into(%{
        gender: "male",
        year_of_birth: 1999,
        user_id: user.id
      })
      |> Pento.Survey.create_demographic()

    demographic
  end

  @doc """
  Generate a rating.
  """
  def rating_fixture(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()
    product = CatalogFixtures.product_fixture()

    {:ok, rating} =
      attrs
      |> Enum.into(%{
        stars: 3,
        user_id: user.id,
        product_id: product.id
      })
      |> Pento.Survey.create_rating()

    rating
  end
end

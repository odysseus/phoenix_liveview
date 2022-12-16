defmodule Pento.SurveyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Survey` context.
  """

  alias Pento.AccountsFixtures
  alias Pento.CatalogFixtures

  def valid_demographic_attrs(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()

    Enum.into(attrs, %{
      gender: "female",
      year_of_birth: DateTime.utc_now().year - 22,
      user_id: user.id
    })
  end

  @doc """
  Generate a demographic.
  """
  def demographic_fixture(attrs \\ %{}) do
    {:ok, demographic} =
      attrs
      |> valid_demographic_attrs()
      |> Pento.Survey.create_demographic()

    demographic
  end

  def create_demographic(attrs \\ %{}) do
    %{demographic: demographic_fixture(attrs)}
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

  def create_rating(attrs \\ %{}) do
    %{rating: rating_fixture(attrs)}
  end
end

defmodule Pento.SurveyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Survey` context.
  """
  alias Pento.CatalogFixtures
  alias Pento.AccountsFixtures

  def valid_demographic_attrs(%{user: user} = attrs) do
    Enum.into(attrs, %{
      gender: "female",
      year_of_birth: DateTime.utc_now().year - 22,
      user_id: user.id
    })
  end

  @doc """
  Generate a demographic.
  """
  def demographic_fixture(%{user: _} = attrs) do
    {:ok, demographic} =
      attrs
      |> valid_demographic_attrs()
      |> Pento.Survey.create_demographic()

    demographic
  end

  def create_demographic(%{user: _} = attrs) do
    %{demographic: demographic_fixture(attrs)}
  end

  def valid_rating_attrs(%{user: user, product: product} = attrs) do
    Enum.into(attrs, %{
      stars: 3,
      user_id: user.id,
      product_id: product.id
    })
  end

  @doc """
  Generate a rating.
  """
  def rating_fixture(%{user: _, product: _} = attrs) do
    {:ok, rating} =
      valid_rating_attrs(attrs)
      |> Pento.Survey.create_rating()

    rating
  end

  def create_rating(%{user: _, product: _} = attrs) do
    %{rating: rating_fixture(attrs)}
  end

  @doc """
  Returns a struct for `user` ensuring that it has demographic information
  stored in the database.
  """
  def survey_user_fixture(attrs \\ %{}) do
    user = attrs[:user] || AccountsFixtures.user_fixture(attrs)
    demographic_fixture(Map.put(attrs, :user, user))

    user
  end

  @doc """
  Creates a user with demographic information which is needed by the
  survey query database functions.

  Returns only a map with `%{user: user}`. If demographic key is needed
  it's best to use `create_user/1` followed by `create_demographic/1`.
  """
  def create_survey_user(attrs \\ %{}) do
    %{user: survey_user_fixture(attrs)}
  end

  @doc """
  For ratings to function correctly they need to link to a product
  and a user with full demographic information. This helper creates
  both of those things to ensure that tests don't fail over a random
  missing piece of DB information.

  Often we only want to create _either_ a new user or a new product,
  but not both. In that case be sure to pass in either `%{user: user}`
  or `%{product: product}` with the `attrs` map. Note that if we pass
  a `:user` value be sure to create demographic information for them.
  """
  def new_rating_fixture(attrs) do
    defaults = %{
      user: attrs[:user] || survey_user_fixture(),
      product: attrs[:product] || CatalogFixtures.product_fixture()
    }

    rating_fixture(Enum.into(attrs, defaults))
  end
end

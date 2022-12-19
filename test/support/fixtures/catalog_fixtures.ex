defmodule Pento.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Catalog` context.
  """

  @doc """
  Generate a unique product sku.
  """
  def unique_product_sku, do: System.unique_integer([:positive])

  def valid_product_attrs(attrs \\ %{}) do
    Enum.into(attrs, %{
      description: "test description",
      name: "Example Game",
      sku: unique_product_sku(),
      unit_price: 37.37
    })
  end

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(valid_product_attrs())
      |> Pento.Catalog.create_product()

    product
  end

  def create_product(attrs \\ %{}) do
    %{product: product_fixture(attrs)}
  end
end

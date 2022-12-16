defmodule Pento.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Catalog` context.
  """

  alias Pento.Repo
  alias Pento.Catalog.Product

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

  def all_products_fixture(_) do
    products = [
      %{
        name: "Chess",
        description: "The medieval strategy game",
        sku: 5_678_910,
        unit_price: 10.00
      },
      %{
        name: "Tic-Tac-Toe",
        description: "The game of Xs and Os",
        sku: 11_121_314,
        unit_price: 3.00
      },
      %{
        name: "Table Tennis",
        description: "Tennis, but table-sized",
        sku: 15_222_324,
        unit_price: 12.00
      }
    ]

    Enum.map(products, fn %{sku: sku} -> Repo.get_by(Product, sku: sku) end)
  end
end

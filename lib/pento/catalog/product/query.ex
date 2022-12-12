defmodule Pento.Catalog.Product.Query do
  import Ecto.Query
  alias Pento.Survey.Demographic
  alias Pento.Catalog.Product
  alias Pento.Survey.Rating
  alias Pento.Accounts.User

  def base, do: Product

  def with_user_ratings(user) do
    base()
    |> preload_user_ratings(user)
  end

  def preload_user_ratings(query, user) do
    ratings_query = Rating.Query.preload_user(user)

    query
    |> preload(ratings: ^ratings_query)
  end

  def all_product_names do
    base()
    |> select([p], p.name)
  end

  def with_average_ratings(query \\ base()) do
    query
    |> join_ratings
    |> average_ratings
  end

  defp join_ratings(query) do
    query
    |> join(:inner, [p], r in Rating, on: r.product_id == p.id)
  end

  defp average_ratings(query) do
    query
    |> group_by([p], p.id)
    |> select([p, r], {p.name, fragment("?::float", avg(r.stars))})
  end

  def join_users(query \\ base()) do
    query
    |> join(:left, [p, r], u in User, on: r.user_id == u.id)
  end

  def join_demographics(query \\ base()) do
    query
    |> join(:left, [p, r, u, d], d in Demographic, on: d.user_id == u.id)
  end

  def filter_by_age_group(query \\ base(), filter) do
    query
    |> apply_age_group_filter(filter)
  end

  defp apply_age_group_filter(query, filter) do
    {year_min, year_max} = birth_year_range(filter)

    query
    |> where(
      [p, r, u, d],
      d.year_of_birth >= ^year_min and d.year_of_birth < ^year_max
    )
  end

  defp this_year(), do: DateTime.utc_now().year

  defp birth_year_range("18 and under") do
    {this_year() - 18, this_year()}
  end

  defp birth_year_range("18 to 25") do
    {this_year() - 25, this_year() - 18}
  end

  defp birth_year_range("25 to 35") do
    {this_year() - 35, this_year() - 25}
  end

  defp birth_year_range("35 to 50") do
    {this_year() - 50, this_year() - 35}
  end

  defp birth_year_range("50 and up") do
    {this_year() - 120, this_year() - 50}
  end

  defp birth_year_range("All") do
    {this_year() - 120, this_year()}
  end

  def valid_age_ranges() do
    [
      "All",
      "18 and under",
      "18 to 25",
      "25 to 35",
      "35 to 50",
      "50 and up"
    ]
  end
end

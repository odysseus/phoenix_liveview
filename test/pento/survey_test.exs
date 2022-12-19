defmodule Pento.SurveyTest do
  use Pento.DataCase

  alias Pento.Survey
  import Pento.CatalogFixtures
  import Pento.AccountsFixtures

  describe "demographics" do
    alias Pento.Survey.Demographic
    alias Pento.Survey

    import Pento.SurveyFixtures

    @invalid_attrs %{gender: nil, year_of_birth: nil}
    setup [:create_user, :create_demographic]

    test "list_demographics/0 returns all demographics", %{demographic: demographic} do
      assert Survey.list_demographics() == [demographic]
    end

    test "get_demographic!/1 returns the demographic with given id", %{demographic: demographic} do
      assert Survey.get_demographic!(demographic.id) == demographic
    end

    test "create_demographic/1 with valid data creates a demographic" do
      user = user_fixture()
      valid_attrs = %{gender: "female", year_of_birth: 1986, user_id: user.id}

      assert {:ok, %Demographic{} = demographic} = Survey.create_demographic(valid_attrs)
      assert demographic.gender == "female"
      assert demographic.year_of_birth == 1986
    end

    test "create_demographic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Survey.create_demographic(@invalid_attrs)
    end

    test "update_demographic/2 with valid data updates the demographic", %{
      user: user,
      demographic: demographic
    } do
      update_attrs = %{gender: "prefer not to say", year_of_birth: 1977, user_id: user.id}

      assert {:ok, %Demographic{} = demographic} =
               Survey.update_demographic(demographic, update_attrs)

      assert demographic.gender == "prefer not to say"
      assert demographic.year_of_birth == 1977
    end

    test "update_demographic/2 with invalid data returns error changeset", %{
      demographic: demographic
    } do
      assert {:error, %Ecto.Changeset{}} = Survey.update_demographic(demographic, @invalid_attrs)
      assert demographic == Survey.get_demographic!(demographic.id)
    end

    test "delete_demographic/1 deletes the demographic", %{demographic: demographic} do
      assert {:ok, %Demographic{}} = Survey.delete_demographic(demographic)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_demographic!(demographic.id) end
    end

    test "change_demographic/1 returns a demographic changeset", %{demographic: demographic} do
      assert %Ecto.Changeset{} = Survey.change_demographic(demographic)
    end

    test "only allows one demographic per user", %{user: user} do
      Survey.create_demographic(%{gender: "nonbinary", year_of_birth: 1991, user_id: user.id})

      assert {:error, %Ecto.Changeset{valid?: false}} =
               Survey.create_demographic(%{year_of_birth: 1992, user_id: user.id})
    end
  end

  describe "ratings" do
    alias Pento.Survey.Rating

    import Pento.SurveyFixtures

    @invalid_attrs %{stars: nil}
    setup [:create_user, :create_product, :create_demographic, :create_rating]

    test "list_ratings/0 returns all ratings", %{rating: rating} do
      assert Survey.list_ratings() == [rating]
    end

    test "get_rating!/1 returns the rating with given id", %{rating: rating} do
      assert Survey.get_rating!(rating.id) == rating
    end

    test "create_rating/1 with valid data creates a rating" do
      user = user_fixture()
      product = product_fixture()
      valid_attrs = %{stars: 3, user_id: user.id, product_id: product.id}

      assert {:ok, %Rating{} = rating} = Survey.create_rating(valid_attrs)
      assert rating.stars == 3
    end

    test "create_rating/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Survey.create_rating(@invalid_attrs)
    end

    test "update_rating/2 with valid data updates the rating", %{rating: rating} do
      update_attrs = %{stars: 5}

      assert {:ok, %Rating{} = rating} = Survey.update_rating(rating, update_attrs)
      assert rating.stars == 5
    end

    test "update_rating/2 with invalid data returns error changeset", %{rating: rating} do
      assert {:error, %Ecto.Changeset{}} = Survey.update_rating(rating, @invalid_attrs)
      assert rating == Survey.get_rating!(rating.id)
    end

    test "delete_rating/1 deletes the rating", %{rating: rating} do
      assert {:ok, %Rating{}} = Survey.delete_rating(rating)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_rating!(rating.id) end
    end

    test "change_rating/1 returns a rating changeset", %{rating: rating} do
      assert %Ecto.Changeset{} = Survey.change_rating(rating)
    end
  end

  describe "demographic queries" do
    alias Pento.Survey
    import Pento.SurveyFixtures

    setup [:create_user]

    test "for_user/2 returns the proper demographic" do
      user = user_fixture()
      demographic = demographic_fixture(%{gender: "female", year_of_birth: 1995, user: user})

      retrieved = Survey.get_demographic_by_user(user)

      assert demographic.user_id == retrieved.user_id
    end
  end
end

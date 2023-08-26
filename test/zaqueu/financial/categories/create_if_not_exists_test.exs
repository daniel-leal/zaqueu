defmodule Zaqueu.Financial.Categories.CreateIfNotExistsTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.Category
  alias Zaqueu.Repo

  describe "create_if_not_exists" do
    test "when all params are valid, should create a category" do
      category_params = params_for(:category, %{description: "Transport"})
      category2_params = params_for(:category, %{description: "Transport"})

      response = Financial.create_category_if_not_exists(category_params)
      Financial.create_category_if_not_exists(category2_params)

      assert response.description == "Transport"

      categories_count = Category |> Repo.all() |> length
      assert categories_count == 1
    end
  end
end

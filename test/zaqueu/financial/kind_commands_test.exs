defmodule Zaqueu.Financial.KindCommandsTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.Kind
  alias Zaqueu.Repo

  describe "create_if_not_exists" do
    test "when all params are valid, should create a kind" do
      kind_params = params_for(:kind, %{description: "Credit Card"})
      kind2_params = params_for(:kind, %{description: "Credit Card"})

      response = Financial.create_kind_if_not_exists(kind_params)
      Financial.create_kind_if_not_exists(kind2_params)

      assert response.description == "Credit Card"

      categories_count = Kind |> Repo.all() |> length
      assert categories_count == 1
    end
  end
end

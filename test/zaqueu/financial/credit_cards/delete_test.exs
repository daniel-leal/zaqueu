defmodule Zaqueu.Financial.CreditCards.DeleteTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.CreditCard
  alias Zaqueu.Repo

  describe "delete/1" do
    test "success delete credit_card" do
      credit_card = insert(:credit_card)

      {:ok, deleted_credit_card} = Financial.delete_credit_card(credit_card)

      query_result = Repo.get(CreditCard, credit_card.id)

      assert deleted_credit_card.id == credit_card.id
      assert is_nil(query_result)
    end
  end
end

defmodule Zaqueu.Financial.Transactions.DeleteTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.Transaction
  alias Zaqueu.Repo

  describe "delete/1" do
    test "success delete transaction" do
      transaction = insert(:transaction)

      {:ok, deleted_transaction} = Financial.delete_transaction(transaction)

      query_result = Repo.get(Transaction, deleted_transaction.id)

      assert deleted_transaction.id == transaction.id
      assert is_nil(query_result)
    end
  end
end

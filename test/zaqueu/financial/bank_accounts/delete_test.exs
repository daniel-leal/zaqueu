defmodule Zaqueu.Financial.BankAccounts.DeleteTest do
  use Zaqueu.DataCase, async: true

  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.BankAccount
  alias Zaqueu.Repo

  describe "delete/1" do
    test "success delete bank account" do
      bank_account = insert(:bank_account)

      {:ok, deleted_bank_account} = Financial.delete_bank_account(bank_account)

      query_result = Repo.get(BankAccount, deleted_bank_account.id)

      assert deleted_bank_account.id == bank_account.id
      assert is_nil(query_result)
    end
  end
end

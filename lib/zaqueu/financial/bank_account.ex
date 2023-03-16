defmodule Zaqueu.Financial.BankAccount do
  alias Zaqueu.Financial
  alias Zaqueu.Identity

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bank_accounts" do
    field(:account_number, :string)
    field(:agency, :string)
    field(:initial_balance, :decimal)
    field(:initial_balance_date, :date)
    field(:bank_id, :binary_id)
    field(:user_id, :binary_id)

    belongs_to(:bank, Financial.Bank, define_field: false)
    belongs_to(:user, Identity.User, define_field: false)

    timestamps()
  end

  @doc false
  def changeset(bank_account, attrs) do
    bank_account
    |> cast(attrs, [
      :initial_balance,
      :initial_balance_date,
      :agency,
      :account_number,
      :bank_id,
      :user_id
    ])
    |> validate_required([
      :user_id,
      :bank_id,
      :initial_balance,
      :initial_balance_date,
      :agency,
      :account_number
    ])
    |> validate_number(:initial_balance, greater_than_or_equal_to: 0)
    |> validate_length(:agency, min: 3)
    |> validate_length(:account_number, min: 3)
  end
end

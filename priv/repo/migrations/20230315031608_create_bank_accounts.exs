defmodule Zaqueu.Repo.Migrations.CreateBankAccounts do
  use Ecto.Migration

  def change do
    create table(:bank_accounts, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:initial_balance, :decimal, precision: 20, scale: 2)
      add(:initial_balance_date, :date)
      add(:agency, :string)
      add(:account_number, :string)
      add(:bank_id, references(:banks, on_delete: :nothing, type: :binary_id))
      add(:user_id, references(:users, on_delete: :nothing, type: :binary_id))

      timestamps()
    end

    create(index(:bank_accounts, [:bank_id]))
    create(index(:bank_accounts, [:user_id]))
  end
end

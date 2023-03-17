defmodule Zaqueu.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:expiry_date, :date)
      add(:is_open, :boolean, default: false, null: false)
      add(:amount, :decimal, precision: 20, scale: 2)
      add(:is_paid, :boolean, default: false, null: false)
      add(:credit_card_id, references(:credit_cards, on_delete: :delete_all, type: :binary_id))
      add(:user_id, references(:users, on_delete: :delete_all, type: :binary_id))

      timestamps()
    end

    create(index(:invoices, [:credit_card_id]))
    create(index(:invoices, [:user_id]))
  end
end

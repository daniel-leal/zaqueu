defmodule Zaqueu.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:description, :string)
      add(:amount, :decimal)
      add(:date, :date)
      add(:category_id, references(:categories, on_delete: :nothing, type: :binary_id))
      add(:invoice_id, references(:invoices, on_delete: :delete_all, type: :binary_id))
      add(:kind_id, references(:kinds, on_delete: :nothing, type: :binary_id))

      timestamps()
    end

    create(index(:transactions, [:category_id]))
    create(index(:transactions, [:invoice_id]))
    create(index(:transactions, [:kind_id]))
  end
end

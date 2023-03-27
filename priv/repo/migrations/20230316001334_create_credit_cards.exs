defmodule Zaqueu.Repo.Migrations.CreateCreditCards do
  use Ecto.Migration

  def change do
    create table(:credit_cards, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:description, :string)
      add(:flag, :string)
      add(:expiry_day, :integer)
      add(:closing_day, :integer)
      add(:limit, :decimal, precision: 20, scale: 2)
      add(:user_id, references(:users, on_delete: :nothing, type: :binary_id))

      timestamps()
    end

    create(index(:credit_cards, [:user_id]))
  end
end

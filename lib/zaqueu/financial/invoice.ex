defmodule Zaqueu.Financial.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "invoices" do
    field :amount, :decimal
    field :expiry_date, :date
    field :is_open, :boolean, default: false
    field :is_paid, :boolean, default: false
    field :credit_card_id, :binary_id
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:expiry_date, :open, :amount, :paid])
    |> validate_required([:expiry_date, :open, :amount, :paid])
  end
end

defmodule Zaqueu.Financial.Schemas.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Zaqueu.Financial.Queries.{InvoiceQueries, KindQueries}
  alias Zaqueu.Financial.Schemas.{Category, Invoice, Kind}
  alias ZaqueuWeb.DisplayHelpers

  @required_fields [:amount, :date, :description, :category_id, :kind_id]
  @optional_fields [:invoice_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field(:amount, :decimal)
    field(:date, :date)
    field(:description, :string)

    belongs_to(:category, Category)
    belongs_to(:invoice, Invoice)
    belongs_to(:kind, Kind)

    timestamps()
  end

  @doc false
  def changeset(transaction \\ %__MODULE__{}, attrs) do
    transaction
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_credit_card_transaction()
  end

  defp validate_credit_card_transaction(changeset) do
    kind_id = get_field(changeset, :kind_id)

    case KindQueries.get_kind_by_id(kind_id) do
      %Kind{description: "Cartão de Crédito"} ->
        changeset
        |> validate_required(:invoice_id)
        |> validate_date_within_invoice_period()

      _ ->
        changeset
    end
  end

  defp validate_date_within_invoice_period(changeset) do
    date = get_field(changeset, :date)
    invoice_id = get_field(changeset, :invoice_id)

    if is_nil(invoice_id) do
      changeset
    else
      %Invoice{start_date: start_date, closing_date: closing_date} =
        InvoiceQueries.get_invoice_by_id!(invoice_id)

      if Timex.after?(date, start_date) and Timex.before?(date, closing_date) do
        changeset
      else
        add_error(
          changeset,
          :date,
          "A data da transação deve estar dentro do período da fatura, de: " <>
            "#{DisplayHelpers.local_date(start_date)} até " <>
            "#{DisplayHelpers.local_date(closing_date)}"
        )
      end
    end
  end
end

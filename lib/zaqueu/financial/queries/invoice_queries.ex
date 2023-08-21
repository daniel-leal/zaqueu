defmodule Zaqueu.Financial.Queries.InvoiceQueries do
  import Ecto.Query, warn: false

  alias Zaqueu.Financial.Schemas.Invoice
  alias Zaqueu.Financial.Schemas.Transaction
  alias Zaqueu.Repo

  @doc """
  Returns the list of invoices of specific credit_card.

  ## Examples

      iex> list_invoices(credit_card_id)
      [%Invoice{}, ...]

  """
  def list_invoices(credit_card_id) do
    query =
      from(i in Invoice,
        where: i.credit_card_id == ^credit_card_id,
        order_by: i.expiry_date
      )

    query
    |> Repo.all()
    |> Enum.map(&Invoice.fill_virtual_fields/1)
  end

  @doc """
  Gets a single invoice.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice!(123)
      %Invoice{}

      iex> get_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice_by_id!(nil), do: nil
  def get_invoice_by_id!(id), do: Repo.get!(Invoice, id)

  @doc """
  Returns a sum of invoices by credit_card_id.

  ## Examples

      iex> get_total_invoices_by_credit_card(credit_card_id)
      Decimal.new(3254.15)

  """
  def get_total_invoices_by_credit_card(credit_card_id) do
    query =
      from(t in Transaction,
        join: i in Invoice,
        on: i.id == t.invoice_id,
        select: sum(t.amount),
        where: i.credit_card_id == ^credit_card_id
      )

    Repo.one(query)
  end

  @doc """
  Returns the invoice sum by its transactions

  ## Examples

      iex> get_total_by_invoice_id(invoice_id)
      Decimal.new(3254.15)

  """
  def get_total_by_invoice_id(invoice_id) do
    Repo.one(
      from(t in Transaction,
        select: sum(t.amount),
        where: t.invoice_id == ^invoice_id
      )
    )
  end

  @doc """
  Gets a invoice month.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice_month_name!(123)
      "Julho"

      iex> get_invoice_month_name!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice_month_name(id) do
    invoice = get_invoice_by_id!(id)
    Timex.lformat!(invoice.start_date, "%B", "pt", :strftime)
  end
end

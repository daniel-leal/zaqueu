defmodule Zaqueu.Financial.Queries.InvoiceQueries do
  import Ecto.Query, warn: false

  alias Zaqueu.Financial.Schemas.Invoice
  alias Zaqueu.Repo

  def list(credit_card_id) do
    query =
      from(i in Invoice,
        where: i.credit_card_id == ^credit_card_id,
        order_by: i.expiry_date
      )

    query
    |> Repo.all()
    |> Enum.map(&Invoice.fill_virtual_fields/1)
  end

  def get_by_id!(id), do: Repo.get!(Invoice, id)

  def sum_by_credit_card(credit_card_id) do
    Repo.one(
      from(i in Invoice,
        select: sum(i.amount),
        where: i.credit_card_id == ^credit_card_id
      )
    )
  end
end

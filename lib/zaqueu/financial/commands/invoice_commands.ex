defmodule Zaqueu.Financial.Commands.InvoiceCommands do
  alias Zaqueu.Financial.Schemas.Invoice
  alias Zaqueu.Repo

  def update(%Invoice{} = invoice, attrs) do
    invoice
    |> Invoice.update_changeset(attrs)
    |> Repo.update()
  end

  def change(%Invoice{} = invoice, attrs \\ %{}) do
    Invoice.update_changeset(invoice, attrs)
  end
end

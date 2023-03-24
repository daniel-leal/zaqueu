defmodule Zaqueu.Financial.Commands.InvoiceCommands do
  alias Zaqueu.Financial.Schemas.Invoice

  def change(%Invoice{} = invoice, attrs \\ %{}) do
    Invoice.update_changeset(invoice, attrs)
  end
end

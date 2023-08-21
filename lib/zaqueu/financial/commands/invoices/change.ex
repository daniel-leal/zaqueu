defmodule Zaqueu.Financial.Commands.Invoices.Change do
  alias Zaqueu.Financial.Schemas.Invoice

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.

  ## Examples

      iex> change(invoice)
      %Ecto.Changeset{data: %Invoice{}}

  """
  def change(%Invoice{} = invoice, attrs \\ %{}) do
    Invoice.update_changeset(invoice, attrs)
  end
end

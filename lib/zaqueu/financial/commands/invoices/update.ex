defmodule Zaqueu.Financial.Commands.Invoices.Update do
  alias Zaqueu.Financial.Schemas.Invoice
  alias Zaqueu.Repo

  @doc """
  Updates a invoice.

  ## Examples

      iex> update(invoice, %{field: new_value})
      {:ok, %Invoice{}}

      iex> update(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Invoice{} = invoice, attrs) do
    invoice
    |> Invoice.update_changeset(attrs)
    |> Repo.update()
  end
end

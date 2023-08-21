defmodule Zaqueu.Financial.Commands.CreditCards.Create do
  alias Ecto.Multi
  alias Zaqueu.Financial
  alias Zaqueu.Financial.Schemas.{CreditCard, Invoice}
  alias Zaqueu.Repo

  @doc """
  Creates a credit_card.

  ## Examples

      iex> create(%{field: value})
      {:ok, %CreditCard{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:credit_card, CreditCard.changeset(%CreditCard{}, attrs))
    |> Multi.insert_all(:invoices, Invoice, fn %{credit_card: credit_card} ->
      Financial.generate_invoices(credit_card)
    end)
    |> Repo.transaction()
  end
end

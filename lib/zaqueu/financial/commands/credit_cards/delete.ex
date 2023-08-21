defmodule Zaqueu.Financial.Commands.CreditCards.Delete do
  alias Zaqueu.Financial.Schemas.CreditCard
  alias Zaqueu.Repo

  @doc """
  Deletes a credit_card.

  ## Examples

      iex> delete(credit_card)
      {:ok, %CreditCard{}}

      iex> delete(credit_card)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%CreditCard{} = credit_card) do
    Repo.delete(credit_card)
  end
end

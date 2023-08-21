defmodule Zaqueu.Financial.Commands.CreditCards.Change do
  alias Zaqueu.Financial.Schemas.CreditCard

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credit_card changes.

  ## Examples

      iex> change(credit_card)
      %Ecto.Changeset{data: %CreditCard{}}

  """
  def change(%CreditCard{} = credit_card, attrs \\ %{}) do
    CreditCard.changeset(credit_card, attrs)
  end
end

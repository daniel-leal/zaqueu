defmodule Zaqueu.Financial.Commands.CreditCards.Update do
  alias Zaqueu.Financial.Schemas.CreditCard
  alias Zaqueu.Repo

  @doc """
  Updates a credit_card.

  ## Examples

      iex> update(credit_card, %{field: new_value})
      {:ok, %CreditCard{}}

      iex> update(credit_card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%CreditCard{} = credit_card, attrs) do
    credit_card
    |> CreditCard.changeset(attrs)
    |> Repo.update()
  end
end

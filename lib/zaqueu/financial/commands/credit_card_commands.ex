defmodule Zaqueu.Financial.Commands.CreditCardCommands do
  alias Zaqueu.Financial.Schemas.CreditCard
  alias Zaqueu.Repo

  def create(attrs \\ %{}) do
    %CreditCard{}
    |> CreditCard.changeset(attrs)
    |> Repo.insert()
  end

  def update(%CreditCard{} = credit_card, attrs) do
    credit_card
    |> CreditCard.changeset(attrs)
    |> Repo.update()
  end

  def delete(%CreditCard{} = credit_card) do
    Repo.delete(credit_card)
  end

  def change(%CreditCard{} = credit_card, attrs \\ %{}) do
    CreditCard.changeset(credit_card, attrs)
  end
end

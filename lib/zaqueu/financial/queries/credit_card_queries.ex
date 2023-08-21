defmodule Zaqueu.Financial.Queries.CreditCardQueries do
  import Ecto.Query, warn: false

  alias Zaqueu.Financial.Schemas.CreditCard
  alias Zaqueu.Repo

  @doc """
  Returns the list of credit_cards.

  ## Examples

      iex> list_credit_cards()
      [%CreditCard{}, ...]

  """
  def list_credit_cards(user_id) do
    Repo.all(
      from(c in CreditCard,
        where: c.user_id == ^user_id,
        order_by: c.description
      )
    )
  end

  @doc """
  Gets a single credit_card.

  Raises `Ecto.NoResultsError` if the Credit card does not exist.

  ## Examples

      iex> get_credit_card!(123)
      %CreditCard{}

      iex> get_credit_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_credit_card_by_id!(id), do: Repo.get!(CreditCard, id)
end

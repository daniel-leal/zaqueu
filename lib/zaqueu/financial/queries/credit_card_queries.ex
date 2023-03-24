defmodule Zaqueu.Financial.Queries.CreditCardQueries do
  import Ecto.Query, warn: false

  alias Zaqueu.Financial.Schemas.CreditCard
  alias Zaqueu.Repo

  def list(user_id) do
    Repo.all(
      from(c in CreditCard,
        where: c.user_id == ^user_id,
        order_by: c.description
      )
    )
  end

  def get_by_id!(id), do: Repo.get!(CreditCard, id)

  def flags do
    ["Amex", "Elo", "Hipercard", "MasterCard", "Visa"]
  end
end

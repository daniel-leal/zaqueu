defmodule Zaqueu.Financial.Queries.CreditCardQueries do
  alias Zaqueu.Financial.Schemas.CreditCard
  alias Zaqueu.Repo

  def list do
    Repo.all(CreditCard)
  end

  def get_by_id!(id), do: Repo.get!(CreditCard, id)
end

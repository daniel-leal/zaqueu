defmodule Zaqueu.Financial.Queries.BankQueries do
  import Ecto.Query, warn: false

  alias Zaqueu.Repo

  alias Zaqueu.Financial.Schemas.Bank

  @doc """
  Returns the list of banks.

  ## Examples

      iex> list_banks()
      [%Bank{}, ...]

  """
  def list_banks do
    Repo.all(
      from(b in Bank,
        order_by: b.name
      )
    )
  end

  @doc """
  Gets a single bank.

  Raises `Ecto.NoResultsError` if the Bank does not exist.

  ## Examples

      iex> get_bank!(123)
      %Bank{}

      iex> get_bank!(456)
      ** (Ecto.NoResultsError)

  """
  def get_by_id(id), do: Repo.get!(Bank, id)

  def filter_by_code(code) do
    query =
      from b in Bank,
        where: b.code == ^code

    Repo.all(query)
  end
end

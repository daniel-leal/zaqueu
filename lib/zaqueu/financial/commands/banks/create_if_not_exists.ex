defmodule Zaqueu.Financial.Commands.Banks.CreateIfNotExists do
  alias Zaqueu.Financial.Queries.BankQueries
  alias Zaqueu.Financial.Schemas.Bank
  alias Zaqueu.Repo

  @doc """
  Creates a bank if it doesn't already exist.

  ## Examples

      iex> create_if_not_exists(%{code: "077", name: "Example Bank"})
      {:ok, %Bank{...}}

  """
  def create_if_not_exists(%{code: code} = attrs) do
    case BankQueries.filter_by_code(code) do
      nil ->
        handle_insert(attrs)

      bank ->
        {:ok, bank}
    end
  end

  defp handle_insert(attrs) do
    %Bank{}
    |> Bank.changeset(attrs)
    |> Repo.insert!()
  end
end

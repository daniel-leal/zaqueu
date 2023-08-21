defmodule Zaqueu.Financial.Queries.KindQueries do
  import Ecto.Query, warn: false

  alias Zaqueu.Financial.Schemas.Kind
  alias Zaqueu.Repo

  @doc """
  Lists card kinds in ascending order of description.

  ## Examples

      iex> list_kinds()
      [%Kind{...}, %Kind{...}, ...]

  """
  def list_kinds do
    query = from(k in Kind, order_by: k.description)
    Repo.all(query)
  end

  @doc """
  Gets a single kind.

  ## Examples

      iex> get_kind_by_description(123)
      %Kind{}

      iex> get_kind_by_description(456)
      nil

  """
  def get_kind_by_description(description) do
    Repo.get_by(Kind, description: description)
  end

  @doc """
  Gets a single Kind.

  Raises `Ecto.NoResultsError` if the Bank does not exist.

  ## Examples

      iex> get_kind_by_id(123)
      %Kind{}

      iex> get_kind_by_id(456)
      nil

  """
  def get_kind_by_id(id), do: Repo.get(Kind, id)
end

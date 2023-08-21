defmodule Zaqueu.Financial.Queries.CategoryQueries do
  import Ecto.Query, warn: false

  alias Zaqueu.Financial.Schemas.Category
  alias Zaqueu.Repo

  @doc """
  Lists categories in ascending order of description.

  ## Examples

      iex> Zaqueu.Financial.Queries.CategoryQueries.list_categories()
      [%Category{...}, %Category{...}, ...]

  """
  def list_categories do
    query = from(c in Category, order_by: c.description)
    Repo.all(query)
  end

  @doc """
  Retrieves a category by its description.

  ## Examples

      iex> get_by_description("Groceries")
      %Category{...}

  """
  def get_by_description(description) do
    Repo.get_by(Category, description: description)
  end

  @doc """
  Retrieves a category by its ID.

  ## Examples

      iex> get_by_id(123)
      %Category{...}

  """
  def get_by_id(id), do: Repo.get!(Category, id)
end

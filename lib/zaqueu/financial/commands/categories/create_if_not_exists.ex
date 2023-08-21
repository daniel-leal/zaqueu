defmodule Zaqueu.Financial.Commands.Categories.CreateIfNotExists do
  alias Zaqueu.Financial.Queries.CategoryQueries
  alias Zaqueu.Financial.Schemas.Category
  alias Zaqueu.Repo

  @doc """
  Creates a category if not exists.

  ## Examples

      iex> create_if_not_exists(%{field: value})
      {:ok, %Category{}}

      iex> create_if_not_exists(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_if_not_exists(%{description: description} = attrs) do
    case CategoryQueries.get_by_description(description) do
      nil ->
        handle_insert(attrs)

      category ->
        {:ok, category}
    end
  end

  defp handle_insert(attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert!()
  end
end

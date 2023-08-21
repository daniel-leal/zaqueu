defmodule Zaqueu.Financial.Commands.Kinds.CreateIfNotExists do
  alias Zaqueu.Financial.Queries.KindQueries
  alias Zaqueu.Financial.Schemas.Kind
  alias Zaqueu.Repo

  @doc """
  Creates a create_kind_if_not_exists.

  ## Examples

      iex> create_kind_if_not_exists(%{field: value})
      {:ok, %Kind{}}

      iex> create_kind_if_not_exists(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_if_not_exists(%{description: description} = attrs) do
    case KindQueries.get_kind_by_description(description) do
      nil ->
        handle_insert(attrs)

      kind ->
        {:ok, kind}
    end
  end

  defp handle_insert(attrs) do
    %Kind{}
    |> Kind.changeset(attrs)
    |> Repo.insert!()
  end
end

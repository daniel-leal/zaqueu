defmodule Zaqueu.Financial.Schemas.Kind do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "kinds" do
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(kind, attrs) do
    kind
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end

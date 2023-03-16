defmodule Zaqueu.Financial.Bank do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "banks" do
    field(:code, :string)
    field(:logo, :string)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(bank, attrs) do
    bank
    |> cast(attrs, [:name, :code, :logo])
    |> validate_required([:name, :code])
    |> unique_constraint(:code)
  end
end

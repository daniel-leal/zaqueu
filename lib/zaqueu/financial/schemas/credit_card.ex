defmodule Zaqueu.Financial.Schemas.CreditCard do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "credit_cards" do
    field(:closing_day, :integer)
    field(:expiry_day, :integer)
    field(:description, :string)
    field(:flag, :string)
    field(:limit, :decimal)
    field(:user_id, :binary_id)

    timestamps()
  end

  @doc false
  def changeset(credit_card, attrs) do
    credit_card
    |> cast(attrs, [
      :expiry_day,
      :description,
      :flag,
      :closing_day,
      :limit,
      :user_id
    ])
    |> validate_required([
      :expiry_day,
      :description,
      :flag,
      :closing_day,
      :limit,
      :user_id
    ])
    |> validate_number(:closing_day, less_than: 32)
    |> validate_number(:expiry_day, less_than: 32)
    |> validate_number(:limit, greater_than: 0)
  end
end

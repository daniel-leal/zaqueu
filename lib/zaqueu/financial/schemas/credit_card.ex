defmodule Zaqueu.Financial.Schemas.CreditCard do
  use Ecto.Schema
  import Ecto.Changeset

  alias Zaqueu.Identity.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "credit_cards" do
    field(:closing_day, :integer)
    field(:expiry_day, :integer)
    field(:description, :string)
    field(:brand, :string)
    field(:limit, :decimal)
    field(:user_id, :binary_id)

    belongs_to(:user, User, define_field: false)

    timestamps()
  end

  @doc false
  def changeset(credit_card, attrs) do
    credit_card
    |> cast(attrs, [
      :expiry_day,
      :description,
      :brand,
      :closing_day,
      :limit,
      :user_id
    ])
    |> validate_required([
      :expiry_day,
      :description,
      :brand,
      :closing_day,
      :limit,
      :user_id
    ])
    |> validate_number(:closing_day, less_than: 32)
    |> validate_number(:expiry_day, less_than: 32)
    |> validate_number(:limit, greater_than: 0)
  end

  @doc """
  Returns a list of supported credit card brands.

  This function returns a list containing the supported credit card brands,
  including "Amex", "Elo", "Hipercard", "MasterCard", and "Visa".

  ## Returns

  A list containing the supported credit card brands.

  """
  def list_brands do
    ["Amex", "Elo", "Hipercard", "MasterCard", "Visa"]
  end
end

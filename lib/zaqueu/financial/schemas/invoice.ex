defmodule Zaqueu.Financial.Schemas.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  alias Zaqueu.Financial.Schemas.CreditCard
  alias Zaqueu.Identity.User

  @status %{
    closed: "Fechado",
    late: "Atrasado",
    open: "Aberto",
    paid: "Pago"
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "invoices" do
    field(:amount, :decimal)
    field(:start_date, :date)
    field(:closing_date, :date)
    field(:expiry_date, :date)
    field(:is_paid, :boolean, default: false)
    field(:credit_card_id, :binary_id)
    field(:user_id, :binary_id)

    field(:payment_status, :string, virtual: true)
    field(:is_current, :boolean, virtual: true)

    belongs_to(:credit_card, CreditCard, define_field: false)
    belongs_to(:user, User, define_field: false)

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [
      :closing_date,
      :start_date,
      :expiry_date,
      :amount,
      :is_paid,
      :credit_card_id,
      :user_id
    ])
    |> validate_required([
      :closing_date,
      :start_date,
      :expiry_date,
      :is_paid,
      :credit_card_id,
      :user_id
    ])
  end

  def update_changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:expiry_date, :is_paid, :amount])
    |> validate_required([:expiry_date, :is_paid])
    |> validate_expiry_date()
    |> validate_amount()
  end

  defp is_current?(%__MODULE__{
         start_date: start_date,
         closing_date: closing_date
       }) do
    today = Timex.today()
    invoice_period = Timex.Interval.new(from: start_date, until: closing_date)
    today in invoice_period
  end

  defp payment_status(%__MODULE__{
         expiry_date: _expiry_date,
         closing_date: _closing_date,
         is_paid: true
       }) do
    @status.paid
  end

  defp payment_status(%__MODULE__{
         expiry_date: expiry_date,
         closing_date: closing_date,
         is_paid: false
       }) do
    today = Timex.today()
    is_late = Timex.after?(today, expiry_date)
    is_closed = Timex.after?(today, closing_date)

    cond do
      is_late && is_closed ->
        @status.late

      is_closed ->
        @status.closed

      true ->
        @status.open
    end
  end

  def fill_virtual_fields(%__MODULE__{} = invoice) do
    invoice
    |> Map.put(:payment_status, payment_status(invoice))
    |> Map.put(:is_current, is_current?(invoice))
  end

  def payable?(%__MODULE__{} = invoice) do
    payment_status(invoice) != @status.open
  end

  defp validate_expiry_date(changeset) do
    validate_change(changeset, :expiry_date, fn :expiry_date, expiry_date ->
      closing_date = get_field(changeset, :closing_date)
      days_diff = Timex.diff(expiry_date, closing_date, :days)

      if days_diff >= 3 and days_diff <= 15 do
        []
      else
        [
          expiry_date:
            "A nova data de vencimento deve ter de 3 a 15 dias após a data de fechamento"
        ]
      end
    end)
  end

  defp validate_amount(changeset) do
    is_paid = get_field(changeset, :is_paid)

    if is_paid do
      changeset
    else
      put_change(changeset, :amount, nil)
    end
  end
end

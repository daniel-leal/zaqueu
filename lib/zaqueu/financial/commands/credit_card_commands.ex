defmodule Zaqueu.Financial.Commands.CreditCardCommands do
  alias Ecto.Multi
  alias Zaqueu.Financial.Schemas.{CreditCard, Invoice}
  alias Zaqueu.Repo

  def create(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:credit_card, CreditCard.changeset(%CreditCard{}, attrs))
    |> Multi.insert_all(:invoices, Invoice, fn %{credit_card: credit_card} ->
      generate_invoices(credit_card)
    end)
    |> Repo.transaction()
  end

  def generate_invoices(credit_card) do
    month = Timex.today().month
    year = Timex.today().year

    Enum.map(month..12, fn m ->
      start_invoice =
        {year, m, credit_card.closing_day}
        |> Timex.to_date()
        |> Timex.shift(days: 1)

      closing_invoice = Timex.shift(start_invoice, months: 1)

      expiry_invoice =
        Timex.shift(start_invoice,
          months: 1,
          days: credit_card.expiry_day - credit_card.closing_day
        )

      timestamp =
        Timex.now()
        |> Timex.to_naive_datetime()
        |> NaiveDateTime.truncate(:second)

      %{
        start_date: start_invoice,
        closing_date: closing_invoice,
        expiry_date: expiry_invoice,
        is_paid: false,
        credit_card_id: credit_card.id,
        user_id: credit_card.user_id,
        inserted_at: timestamp,
        updated_at: timestamp
      }
    end)
  end

  def update(%CreditCard{} = credit_card, attrs) do
    credit_card
    |> CreditCard.changeset(attrs)
    |> Repo.update()
  end

  def delete(%CreditCard{} = credit_card) do
    Repo.delete(credit_card)
  end

  def change(%CreditCard{} = credit_card, attrs \\ %{}) do
    CreditCard.changeset(credit_card, attrs)
  end
end

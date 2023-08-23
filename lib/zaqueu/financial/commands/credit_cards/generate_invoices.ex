defmodule Zaqueu.Financial.Commands.CreditCards.GenerateInvoices do
  def generate_invoices(credit_card) do
    month = Timex.today().month
    year = Timex.today().year

    Enum.map(month..12, fn m ->
      start_invoice = Timex.to_date({year, m, credit_card.closing_day})
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
end

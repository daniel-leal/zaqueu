invoices =
  Enum.map(8..12, fn m ->
    start_invoice = Timex.to_date({2023, m, 7})
    closing_invoice = Timex.shift(start_invoice, months: 1)

    expiry_invoice =
      Timex.shift(start_invoice,
        months: 1,
        days: 14 - 7
      )

    %{
      start_date: start_invoice,
      closing_date: closing_invoice,
      expiry_date: expiry_invoice
    }
  end)

defmodule ZaqueuWeb.DisplayHelpers do
  use Timex

  def money(nil), do: "R$ 0,00"
  def money(value), do: String.replace("R$ #{value}", ".", ",")

  def local_date(date_value) do
    Timex.format!(date_value, "%d/%m/%Y", :strftime)
  end

  def local_datetime(date_value) do
    Timex.format!(date_value, "%d/%m/%Y %H:%M", :strftime)
  end

  def is_between?(date, start, end_date) do
    Timex.between?(date, start, end_date)
  end
end

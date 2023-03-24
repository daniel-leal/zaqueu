use Timex

interval = Interval.new(from: ~D[2023-03-07], until: ~D[2023-04-06])
Timex.today() in interval

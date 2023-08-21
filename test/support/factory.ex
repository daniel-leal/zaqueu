defmodule Support.Factory do
  use ExMachina.Ecto, repo: Zaqueu.Repo

  alias Zaqueu.Financial.Schemas.{
    Bank,
    BankAccount,
    Category,
    CreditCard,
    Invoice,
    Kind,
    Transaction
  }

  alias Zaqueu.Identity.User

  def user_factory do
    %User{
      email: sequence(:email, &"user-#{&1}@email.com"),
      hashed_password: "123123",
      confirmed_at: ~N[2023-03-13 15:00:00]
    }
  end

  def bank_factory do
    %Bank{
      code: sequence(:code, &"00#{&1 + 1}"),
      name: "Banco Xpto",
      logo: "https://elixir-lang.org/images/logo/logo.png"
    }
  end

  def bank_account_factory do
    %BankAccount{
      account_number: "0948",
      agency: "168579",
      initial_balance: "120.50",
      initial_balance_date: ~D[2023-03-14]
    }
  end

  def credit_card_factory do
    %CreditCard{
      closing_day: 7,
      expiry_day: 14,
      description: "Itau Card",
      brand: "MasterCard",
      limit: "1500"
    }
  end

  def invoice_factory do
    %Invoice{
      amount: "0.00",
      start_date: ~D[2023-03-07],
      closing_date: ~D[2023-04-06],
      expiry_date: ~D[2023-04-14],
      is_paid: false
    }
  end

  def category_factory do
    %Category{
      description: "Transport"
    }
  end

  def kind_factory do
    %Kind{
      description: "Credit Card"
    }
  end

  def transaction_factory do
    %Transaction{
      amount: Decimal.new("15.48"),
      date: ~D[2023-04-02],
      description: "Uber",
      category: build(:category),
      kind: build(:kind)
    }
  end
end

class Account < ApplicationRecord
  InsufficientFunds = Class.new(StandardError)

  def sufficient_funds?(amount)
    balance >= amount
  end

  def debit!(amount)
    ensure_positive(amount)
    raise InsufficientFunds, "account has insufficient funds" unless sufficient_funds?(amount)

    update!(balance: balance - amount)
  end

  def credit!(amount)
    ensure_positive(amount)

    update!(balance: balance + amount)
  end

  private

  def ensure_positive(amount)
    raise ArgumentError, "amount must be positive" unless amount.positive?
  end
end

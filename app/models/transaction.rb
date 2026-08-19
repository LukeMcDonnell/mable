class Transaction
  Rejected = Class.new(StandardError)

  UnknownSourceAccount      = Class.new(Rejected)
  UnknownDestinationAccount = Class.new(Rejected)
  SameAccount               = Class.new(Rejected)
  InvalidAmount             = Class.new(Rejected)
  InsufficientFunds         = Class.new(Rejected)

  attr_reader :from_account_number, :to_account_number, :amount

  def initialize(from_account_number, to_account_number, amount)
    @from_account_number = from_account_number
    @to_account_number = to_account_number
    @amount = amount
  end

  def process
    source = Account.find_by(number: from_account_number)
    destination = Account.find_by(number: to_account_number)

    raise UnknownSourceAccount, "unknown source account" if source.nil?
    raise UnknownDestinationAccount, "unknown destination account" if destination.nil?
    raise SameAccount, "source account must be different to destination" if source == destination
    raise InvalidAmount, "amount must be positive" unless amount.positive?
    raise InsufficientFunds, "source account has insufficient funds" unless source.sufficient_funds?(amount)

    ActiveRecord::Base.transaction do
      source.debit!(amount)
      destination.credit!(amount)
    end
  end
end

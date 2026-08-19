require "csv"

class TransactionParser
  def initialize(path)
    @path = path
  end

  def transactions
    CSV.foreach(@path).map do |from_number, to_number, amount|
      Transaction.new(from_number, to_number, BigDecimal(amount))
    end
  end
end

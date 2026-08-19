require "csv"

class BalanceImporter
  def initialize(path)
    @path = path
  end

  def import
    CSV.foreach(@path).map do |number, balance|
      account = Account.find_or_initialize_by(number: number)
      account.update!(balance: BigDecimal(balance))
      account
    end
  end
end

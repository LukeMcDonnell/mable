class TransactionReport
  def initialize(applied, rejected)
    @applied = applied
    @rejected = rejected
  end

  def to_s
    [
      summary,
      section("Applied", applied.map { |transaction| row(transaction) }),
      section("Rejected", rejected.map { |transaction, reason| "#{row(transaction)}   #{reason}" }),
      section("Closing balances", balances)
    ].compact.join("\n\n")
  end

  private

  attr_reader :applied, :rejected

  def summary
    total = applied.size + rejected.size

    "#{total} #{"transfer".pluralize(total)}: #{applied.size} applied, #{rejected.size} rejected"
  end

  def section(heading, lines)
    return if lines.empty?

    [heading, *lines].join("\n")
  end

  def row(transaction)
    "  #{transaction.from_account_number} -> #{transaction.to_account_number} #{money(transaction.amount)}"
  end

  def balances
    Account.order(:number).map { |account| "  #{account.number} #{money(account.balance)}" }
  end

  def money(amount)
    format("%12.2f", amount)
  end
end

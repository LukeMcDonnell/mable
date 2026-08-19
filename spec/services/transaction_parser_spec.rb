require "rails_helper"

RSpec.describe TransactionParser do
  subject(:parser) { described_class.new(file_fixture("mable_transactions.csv").to_s) }

  it "builds one transaction for every row in the file" do
    expect(parser.transactions.size).to eq(4)
  end

  it "keeps the rows in the order the file lists them" do
    expect(parser.transactions.first).to have_attributes(
      from_account_number: "1111234522226789",
      to_account_number: "1212343433335665"
    )
  end

  it "reads the amount as a decimal" do
    amount = parser.transactions.third.amount

    expect(amount).to eq("320.50".to_d)
    expect(amount).to be_a(BigDecimal)
  end
end

require "rails_helper"

RSpec.describe TransactionReport do
  let(:applied) { [Transaction.new("1111234522226789", "1212343433335665", "500.00".to_d)] }
  let(:rejected) do
    [[Transaction.new("3212343433335755", "2222123433331212", "9999.00".to_d),
      "source account has insufficient funds"]]
  end

  before do
    Account.create!(number: "1111234522226789", balance: "4500.00".to_d)
    Account.create!(number: "1212343433335665", balance: "1700.00".to_d)
  end

  it "counts what happened" do
    report = described_class.new(applied, rejected)

    expect(report.to_s).to include("2 transfers: 1 applied, 1 rejected")
  end

  it "lists each transfer that was applied" do
    report = described_class.new(applied, [])

    expect(report.to_s).to include("1111234522226789 -> 1212343433335665", "500.00")
  end

  it "gives the reason alongside each transfer it rejected" do
    report = described_class.new([], rejected)

    expect(report.to_s).to include("source account has insufficient funds")
  end

  it "leaves out the rejected section when nothing was rejected" do
    report = described_class.new(applied, [])

    expect(report.to_s).not_to include("Rejected")
  end

  it "closes with the balance of every account" do
    report = described_class.new(applied, [])

    expect(report.to_s).to include("Closing balances", "1111234522226789", "4500.00")
  end
end

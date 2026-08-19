require "rails_helper"

RSpec.describe BalanceImporter do
  subject(:importer) { described_class.new(file_fixture("mable_account_balances.csv").to_s) }

  it "creates an account for every row in the file" do
    expect { importer.import }.to change(Account, :count).from(0).to(5)
  end

  it "gives each account the balance it was opened with" do
    importer.import

    expect(Account.find_by(number: "1111234522226789").balance).to eq("5000.00".to_d)
  end

  it "returns the accounts it loaded" do
    expect(importer.import.map(&:number)).to include("3212343433335755")
  end

  it "updates the existing accounts when the same file is loaded again" do
    importer.import
    Account.find_by(number: "1111234522226789").debit!("1000.00".to_d)

    importer.import

    expect(Account.count).to eq(5)
    expect(Account.find_by(number: "1111234522226789").balance).to eq("5000.00".to_d)
  end
end

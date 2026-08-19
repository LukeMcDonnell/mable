require "rails_helper"

RSpec.describe Transaction do
  subject(:transaction) { described_class.new(source.number, destination.number, "500.00".to_d) }

  let(:source) { Account.create!(number: "1111234522226789", balance: "5000.00".to_d) }
  let(:destination) { Account.create!(number: "1212343433335665", balance: "1200.00".to_d) }

  describe "#process" do
    it "takes the amount out of the source account" do
      transaction.process

      expect(source.reload.balance).to eq("4500.00".to_d)
    end

    it "puts the amount into the destination account" do
      transaction.process

      expect(destination.reload.balance).to eq("1700.00".to_d)
    end
  end

  describe "#process when it cannot go ahead" do
    it "refuses to move more than the source account holds" do
      transaction = described_class.new(source.number, destination.number, "5000.01".to_d)

      expect { transaction.process }.to raise_error(Transaction::InsufficientFunds)
    end

    it "refuses a source account it cannot find" do
      transaction = described_class.new("9999999999999999", destination.number, "500.00".to_d)

      expect { transaction.process }.to raise_error(Transaction::UnknownSourceAccount)
    end

    it "refuses a destination account it cannot find" do
      transaction = described_class.new(source.number, "9999999999999999", "500.00".to_d)

      expect { transaction.process }.to raise_error(Transaction::UnknownDestinationAccount)
    end

    it "refuses to move money from an account to itself" do
      transaction = described_class.new(source.number, source.number, "500.00".to_d)

      expect { transaction.process }.to raise_error(Transaction::SameAccount)
    end

    it "refuses an amount of nothing" do
      transaction = described_class.new(source.number, destination.number, "0".to_d)

      expect { transaction.process }.to raise_error(Transaction::InvalidAmount)
    end

    it "refuses a negative amount" do
      transaction = described_class.new(source.number, destination.number, "-500.00".to_d)

      expect { transaction.process }.to raise_error(Transaction::InvalidAmount)
    end
  end
end

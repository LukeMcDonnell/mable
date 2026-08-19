require "rails_helper"

RSpec.describe Account do
  subject(:account) { described_class.new(number: "1111234522226789", balance: "5000.00".to_d) }

  describe "#sufficient_funds?" do
    it "covers an amount below the balance" do
      expect(account).to be_sufficient_funds("4999.99".to_d)
    end

    it "covers an amount equal to the whole balance" do
      expect(account).to be_sufficient_funds("5000.00".to_d)
    end

    it "does not cover an amount a cent more than the balance" do
      expect(account).not_to be_sufficient_funds("5000.01".to_d)
    end
  end

  describe "#debit!" do
    before { account.save! }

    it "takes the amount out of the balance" do
      account.debit!("500.00".to_d)

      expect(account.balance).to eq("4500.00".to_d)
    end

    it "persists the new balance" do
      account.debit!("500.00".to_d)

      expect(account.reload.balance).to eq("4500.00".to_d)
    end

    it "allows an account to be emptied exactly" do
      account.debit!("5000.00".to_d)

      expect(account.reload.balance).to eq(0)
    end

    it "refuses to overdraw the account" do
      expect { account.debit!("5000.01".to_d) }.to raise_error(Account::InsufficientFunds)
    end

    it "refuses a negative amount" do
      expect { account.debit!("-1.00".to_d) }.to raise_error(ArgumentError)
    end

    it "refuses a zero amount" do
      expect { account.debit!("0".to_d) }.to raise_error(ArgumentError)
    end
  end

  describe "#credit!" do
    before { account.save! }

    it "adds the amount to the balance" do
      account.credit!("320.50".to_d)

      expect(account.reload.balance).to eq("5320.50".to_d)
    end

    it "refuses a negative amount" do
      expect { account.credit!("-1.00".to_d) }.to raise_error(ArgumentError)
    end

    it "refuses a zero amount" do
      expect { account.credit!("0".to_d) }.to raise_error(ArgumentError)
    end
  end
end

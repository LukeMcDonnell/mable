require "rails_helper"
require "rake"

RSpec.describe "Processing a day's transfers" do
  before do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
    task("accounts:load").reenable
    task("transfers:process").reenable
  end

  it "loads the opening balances, then settles each transfer in the day's file" do
    run "accounts:load", fixture("mable_account_balances.csv")
    run "transfers:process", fixture("mable_transactions.csv")

    expect(balances).to eq(
      "1111234522226789" => "4820.50".to_d,
      "1111234522221234" => "9974.40".to_d,
      "2222123433331212" => "1550.00".to_d,
      "1212343433335665" => "1725.60".to_d,
      "3212343433335755" => "48679.50".to_d
    )
  end

  def run(name, *args)
    capture_stdout { task(name).invoke(*args) }
  end

  def task(name) = Rake::Task[name]

  def fixture(name) = Rails.root.join("spec/fixtures/files", name).to_s

  def balances = Account.pluck(:number, :balance).to_h

  def capture_stdout
    original = $stdout
    $stdout = StringIO.new
    yield
  ensure
    $stdout = original
  end
end

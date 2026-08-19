namespace :accounts do
  desc "Load opening balances from csv"
  task :load, [:path] => :environment do |_task, args|
    accounts = BalanceImporter.new(args.fetch(:path)).import

    puts "Loaded #{accounts.size} account #{"balance".pluralize(accounts.size)}"
  end
end

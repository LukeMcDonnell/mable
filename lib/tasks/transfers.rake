namespace :transfers do
  desc "Process a day's transfers from csv"
  task :process, [:path] => :environment do |_task, args|
    applied = []
    rejected = []

    TransactionParser.new(args.fetch(:path)).transactions.each do |transaction|
      transaction.process
      applied << transaction
    rescue Transaction::Rejected => e
      rejected << [transaction, e.message]
    end

    puts TransactionReport.new(applied, rejected)
  end
end

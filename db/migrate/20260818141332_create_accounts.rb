class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.string  :number,  null: false
      t.decimal :balance, null: false, default: 0, precision: 12, scale: 2

      t.timestamps
    end

    add_index :accounts, :number, unique: true

    add_check_constraint :accounts, "balance >= 0", name: "balance_non_negative"
  end
end

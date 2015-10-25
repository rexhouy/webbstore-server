class CreateAccountBalanceHistories < ActiveRecord::Migration
        def change
                create_table :account_balance_histories do |t|
                        t.decimal :receipt, precision: 8, scale: 2
                        t.decimal :disbursment, precision: 8, scale: 2
                        t.decimal :balance, precision: 8, scale: 2
                        t.string :operator
                        t.references :user
                        t.string :comment

                        t.timestamps null: false
                end
        end
end

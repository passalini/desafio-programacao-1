class AddIncomeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :income, :float
  end
end

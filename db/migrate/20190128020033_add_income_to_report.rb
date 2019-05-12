class AddIncomeToReport < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :income, :float, default: 0
  end
end

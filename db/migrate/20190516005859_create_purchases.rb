class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.integer :count
      t.references :purchaser, foreign_key: true
      t.references :item, foreign_key: true
      t.references :user, foreign_key: true
      t.references :report, foreign_key: true

      t.timestamps
    end
  end
end

class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :address
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

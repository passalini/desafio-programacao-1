class Item < ApplicationRecord
  belongs_to :user
  belongs_to :merchant

  validates :name, :price, presence: :true
end

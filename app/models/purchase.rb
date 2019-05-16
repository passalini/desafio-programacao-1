class Purchase < ApplicationRecord
  belongs_to :purchaser
  belongs_to :item
  belongs_to :user
  belongs_to :report

  validates :count, presence: :true
end

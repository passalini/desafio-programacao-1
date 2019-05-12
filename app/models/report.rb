class Report < ApplicationRecord
    has_one_attached :file

    validates :name, presence: true
    validates_each :file do |record, attr, value|
      record.errors.add(attr, :blank) unless value.attached?
    end
end

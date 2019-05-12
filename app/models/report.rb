require 'csv'

class Report < ApplicationRecord
  has_one_attached :file

  validates :name, presence: true
  validates_each :file, on: :create do |record, attr, value|
    record.errors.add(attr, :blank) unless value.attached?
    record.errors.add(attr, :invalid) unless valid_report?(value)
  end

  # TODO: skip it when updating only name
  before_save :process_file

  private

  def self.valid_report?(report_file)
    return true unless report_file.attached?
    csv = buid_csv(report_file)

    valid_headers = ["purchaser name", "item description", "item price",
      "purchase count", "merchant address", "merchant name"]

    return valid_headers.sort == csv.headers.sort
  end

  def self.buid_csv(file)
    path = ActiveStorage::Blob.service.send(:path_for, file.key)
    CSV.read(path, headers: true, col_sep: "\t")
  end

  def process_file
    return unless self.file.attached?
    csv = self.class.buid_csv(file)

    self.income = 0
    csv.each do |row|
      self.income += row["item price"].to_f * row["purchase count"].to_f
    end
  end
end

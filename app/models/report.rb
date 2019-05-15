require 'csv'

class Report < ApplicationRecord
  include AASM

  has_one_attached :file
  belongs_to :user

  validates :name, presence: true
  validates_each :file, on: :create do |record, attr, value|
    record.errors.add(attr, :blank) unless value.attached?
    record.errors.add(attr, :invalid) unless valid_report?(value)
  end

  after_commit :broadcast_creation, on: :create
  after_commit :process_file_in_background, if: :should_process?
  after_commit -> { user.calculate_income! }, if: :saved_change_to_income?

  aasm do
    state :processing, initial: true
    state :done

    event :process do
      transitions to: :processing
    end

    event :finish_porcessing, before: :calculate_income do
      transitions to: :done
    end
  end

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

  def calculate_income
    csv = self.class.buid_csv(file)

    self.income = 0
    csv.each do |row|
      self.income += row["item price"].to_f * row["purchase count"].to_f
    end
  end

  private

  def should_process?
    file.attached? && file.saved_change_to_blob_id? && process
  end

  def process_file_in_background
    ProcessReportJob.perform_later(self)
  end

  def broadcast_creation
    ActionCable.server.broadcast 'report_notifications_channel',
      report: ViewHelper.render(self)
  end
end

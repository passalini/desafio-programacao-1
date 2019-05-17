require 'csv'

class Report < ApplicationRecord
  include AASM

  has_one_attached :file
  belongs_to :user
  has_many :purchases, dependent: :destroy

  validates :name, presence: true
  validates_each :file, on: :create do |record, attr, value|
    record.errors.add(attr, :blank) unless value.attached?
    record.errors.add(attr, :invalid) unless valid_report?(value)
  end
  validates_each :file do |record, attr, value|
    if !record.new_record? && record.send(:new_file?)
      record.errors.add(attr, :invalid, message: 'should be blank')
    end
  end

  after_commit :broadcast_creation, on: :create
  after_commit :process_file_in_background, if: :new_file?, on: :create
  after_commit -> { user.calculate_income! }, if: -> { saved_change_to_income? || destroyed? }

  aasm do
    state :enqueued, initial: true
    state :done

    event :process, before: :process_file! do
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

  private

  def new_file?
    file.attached? && file.saved_change_to_blob_id?
  end

  def process_file_in_background
    ProcessReportJob.perform_later(self)
  end

  def broadcast_creation
    ActionCable.server.broadcast 'report_notifications_channel',
      report: ViewHelper.render(self)
  end

  def clean_purchases!
    purchases.destroy_all
  end

  def process_file!
    csv = self.class.buid_csv(file)
    self.income = 0

    csv.each do |row|
      merchant = user.merchants.find_or_create_by(name: row['merchant name']) do |merchant|
        merchant.address = row['merchant address']
      end

      purchaser = user.purchasers.find_or_create_by(name: row['purchaser name'])

      item = user.items.find_or_create_by(name: row['item description'], merchant: merchant) do |item|
        item.price = row['item price'].to_f
      end

      purchase = user.purchases.find_or_create_by(report: self, purchaser: purchaser, item: item) do |purchase|
        purchase.count = row['purchase count'].to_i
      end

      self.income += purchase.count * item.price
    end
  end
end

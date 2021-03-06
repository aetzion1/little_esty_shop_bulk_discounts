class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :merchant_id,
                        :customer_id

  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: [:cancelled, :in_progress, :complete]

  def total_revenue
    revenue = 0
    invoice_items.each do |invoice_item|
      revenue += invoice_item.revenue
    end
    revenue
  end

  scope :pending, lambda {where(:status => 1)}

  def self.in_progress_with_discount(threshold)
    pending.joins(:invoice_items)
    .select('invoices.*')
    .where('invoice_items.quantity >= ?', threshold)
  end
end

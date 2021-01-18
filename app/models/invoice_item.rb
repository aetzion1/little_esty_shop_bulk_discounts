class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant
# ^ may not be necessary - use method instead
  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def discount_to_percentage
    if discount_applied
      (self.discount_applied * 100).round
    else
      if best_discount
      (self.best_discount.discount * 100).round
      end
    end
  end

  def self.store_discount
    all.each do |invoice_item|
      if invoice_item.best_discount
        x = invoice_item.best_discount.discount
        invoice_item.update(discount_applied: x)
      end
    end
  end

  def best_discount
    bulk_discounts.best_discount(self)
  end

  def revenue
    if best_discount
      discount_amount = best_discount.discount * unit_price
      discounted_price = unit_price - discount_amount
      discounted_price * quantity
    else
      unit_price * quantity
    end
  end
end

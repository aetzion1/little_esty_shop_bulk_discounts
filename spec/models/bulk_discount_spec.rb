require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :discount }
    it { should validate_presence_of :threshold }
    it { should validate_presence_of :merchant }
  end

  describe "relationships" do
    it { should belong_to :merchant }
  end

  describe "instance methods" do
    it "can convert it's threshold value to a percentage" do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @discount1 = BulkDiscount.create!(name: "Going Out of Business", discount: 0.2, threshold: 2, merchant: @m1)
      
      expect(@discount1.discount_to_percentage).to eq(20)
    end
  end

  describe "class methods" do
    it "can determine the best_discount for an invoice_item" do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz', address: '123 Heyyo', city: 'Whoville', state: 'CO', zip: 12345)
      @i1 = Invoice.create!(merchant_id: @m1.id, customer_id: @c1.id, status: 2, created_at: '2012-03-25 09:54:09')
      @item_1 = Item.create!(name: 'test', description: 'lalala', unit_price: 6, merchant_id: @m1.id)     
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)

      @discount1 = BulkDiscount.create!(name: "Going Out of Business", discount: 0.2, threshold: 2, merchant: @m1)
      @discount2 = BulkDiscount.create!(name: "A little help from a freind", discount: 0.25, threshold: 2, merchant: @m1)
  
      expect(BulkDiscount.best_discount(@ii_1)).to eq(@discount2)
    end
  end

end
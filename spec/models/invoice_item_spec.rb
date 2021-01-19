require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many :bulk_discounts }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchant) }
  end

  before :each do 
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @invoice_1 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
    @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)
    @discount1 = BulkDiscount.create!(name: "Going Out of Business", discount: 0.2, threshold: 2, merchant: @merchant1)
    @discount2 = BulkDiscount.create!(name: "Just a Sale", discount: 0.3, threshold: 10, merchant: @merchant1)
  end

  describe "class methods" do
    it "store_discount" do
    end
  end

  describe 'instance methods' do
    it "total_revenue" do
      expect(@ii_1.revenue).to eq(72)
      expect(@ii_11.revenue).to eq(10)
    end

    it "best discount" do
    end

    it "revenue" do
    end

    it "discount_to_percentage" do
      expect(@ii_1.discount_to_percentage).to eq(20)
    end
  end
end

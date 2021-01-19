require 'rails_helper'

describe "merchant discounts new page" do
  before :each do
    @merchant_a = Merchant.create!(name: "Adam's Apples")
    @customer_1 = Customer.create!(first_name: 'Mike', last_name: 'Lazowski')
	  @item_a1 = Item.create!(name: "Gala", description: "crisp sweet", unit_price: 10, merchant: @merchant_a)
    @item_a2 = Item.create!(name: "Fuji", description: "japanese-style", unit_price: 20, merchant: @merchant_a)
    @invoice_a = Invoice.create!(merchant: @merchant_a, customer: @customer_1, status: 2)
    @transaction_1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice: @invoice_a)
	  @discount_a = BulkDiscount.create!(name: "Going Out of Business", discount: 0.2, threshold: 10, merchant: @merchant_a)

    visit new_merchant_bulk_discount_path(@merchant_a)
  end
  
  it "has a form to create a new discount" do
    visit merchant_bulk_discounts_path(@merchant_a.id)

    expect(page).to_not have_content('Blackest Friday')
    click_link('Offer New Discount')

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_a))
    
    expect(page).to have_button('Submit')

    fill_in :name, with: 'Blackest Friday'
    fill_in :discount, with: 0.5
    fill_in :threshold, with: 9

    click_button('Submit')

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_a.id))

    expect(page).to have_content('Blackest Friday')
    expect(page).to have_content('50%')
    expect(page).to have_content(20)
  end

  #Sad Path
  describe "I create a discount that is worse than an existing one" do
    it "Then I see a message telling me that I already have a better discount" do
      
      fill_in :name, with: 'A Worse Discount'
      fill_in :discount, with: 0.5
      fill_in :threshold, with: 11
  
      click_button('Submit')

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_a))

      expect(page).to have_content('You already have a better discount!')
      expect(page).to have_button('Submit')
    end
  end
   
end
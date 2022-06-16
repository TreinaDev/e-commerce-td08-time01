require 'rails_helper'

describe 'A Price should be created in the past' do
  # # when applying Timecop inside the Price factory, it fails
  
  # it 'by the Factorybot directly' do
  #   product = create(:product, name: 'Sabre Jedi', status: 'draft')
  #   price = create(:price, product: product)

  #   expect(price.validity_start).to be < Time.current
  # end

  it 'by the Factorybot indirectly' do
    product = create(:product, name: 'Sabre Jedi', status: 'draft')
    Timecop.freeze(1.year.ago) do
      create(:price, product: product)
    end

    expect(Price.last.validity_start).to be < Time.current
  end
end
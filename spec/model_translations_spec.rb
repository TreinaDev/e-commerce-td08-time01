require 'rails_helper'

describe 'I18n should be available for model' do
  it 'Price' do
    expect(Price.model_name.human).to eq 'Preço'
    expect(Price.human_attribute_name('price_in_brl')).to eq 'Preço em reais'
    expect(Price.human_attribute_name('product')).to eq 'Produto'
    expect(Price.human_attribute_name('product_id')).to eq 'Produto'
    expect(Price.human_attribute_name('validity_start')).to eq 'Início da validade'
  end
end
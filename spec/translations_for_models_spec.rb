require 'rails_helper'

describe 'I18n translations should be available for model' do
  it 'Price' do
    expect(Price.model_name.human).to eq 'Preço'
    expect(Price.model_name.human(count: 2)).to eq 'Preços'
    expect(Price.human_attribute_name('price_in_brl')).to eq 'Preço em reais'
    expect(Price.human_attribute_name('product')).to eq 'Produto'
    expect(Price.human_attribute_name('product_id')).to eq 'Produto'
    expect(Price.human_attribute_name('validity_start')).to eq 'Início da validade'
  end

  it 'Product' do
    expect(Product.model_name.human).to eq 'Produto'
    expect(Product.model_name.human(count: 2)).to eq 'Produtos'
    expect(Product.human_attribute_name('name')).to eq 'Nome'
    expect(Product.human_attribute_name('brand')).to eq 'Marca'
    expect(Product.human_attribute_name('description')).to eq 'Descrição'
    expect(Product.human_attribute_name('sku')).to eq 'SKU'
  end

  it 'ProductCategory' do
    expect(ProductCategory.model_name.human).to eq 'Categoria de Produtos'
    expect(ProductCategory.model_name.human(count: 2)).to eq 'Categorias de Produtos'
    expect(ProductCategory.human_attribute_name('name')).to eq 'Nome'
    expect(ProductCategory.human_attribute_name('parent')).to eq 'Categoria Pai'
    expect(ProductCategory.human_attribute_name('parent_id')).to eq 'Categoria Pai'
  end
end
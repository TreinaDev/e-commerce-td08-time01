require 'rails_helper'

RSpec.describe Search, type: :feature do
  describe '.new' do
    it 'should instatiate a new Search' do
      # result = Search.new(query: 'chocolate') # por que não funciona?
      result = Search.new('chocolate') 

      expect(result).to be_instance_of Search
      expect(result.query).to eq 'chocolate'
    end
  end

  describe '#sanitize_query' do
    it 'should remove percentage signs (%)' do
      # note that @query is saved sanitized, as opposed to @original_query
      search = Search.new('"chocolate branco" % café "leite condensado"')

      expect(search.query.class).to be String
      expect(search.query).to eq '"chocolate branco"  café "leite condensado"'
    end

    it 'should remove underscore signs (_) in the beginning or ending of words' do
      search = Search.new('chocolate_branco café "leite condensado"')

      expect(search.query).to eq '"chocolate branco" café "leite condensado"'
    end

    it 'should substitute underscore signs (_) by spaces and apply quotes' do
      search = Search.new('chocolate_branco café "leite condensado"')

      expect(search.query).to eq '"chocolate branco" café "leite condensado"'
    end

    it 'should not change the original query' do
      search = Search.new('_chocolate branco % "leite condensado"')

      expect(search.original_query).to eq '_chocolate branco % "leite condensado"'
    end
  end

  describe '#split_keywords' do
    it 'should return an array of keywords' do
      result = Search.new('chocolate branco').split_keywords

      expect(result.class).to be Array
      expect(result).to eq ['chocolate', 'branco']
    end

    it 'should respect expressions inside quotation marks' do
      search = Search.new('"chocolate branco" café "leite condensado"')

      result = search.split_keywords

      expect(result).to include 'chocolate branco'
      expect(result).to include 'leite condensado'
      expect(result).to include 'café'
      expect(result.size).to eq 3
    end

    it 'should not change the original query' do
      search = Search.new('chocolate branco "leite condensado"')

      result = search.split_keywords

      expect(search.original_query).to eq 'chocolate branco "leite condensado"'
    end
  end

  describe '#inside_products' do
    it 'should find products by name, regardless of letter case' do
      product1 = create(:product, name: 'Prancha de Surf')
      product2 = create(:product, name: 'Wetsuit para SURF')
      product3 = create(:product, name: 'Malucos do kitesurf')
      product4 = create(:product, name: 'Caneca de café')
      
      results = Search.new('surf').inside_products

      expect(results).to include product1
      expect(results).to include product2
      expect(results).to include product3
      expect(results).not_to include product4
    end

    it 'should find products by description, regardless of letter case' do
      product1 = create(:product, description: 'Prancha para surfar')
      product2 = create(:product, description: 'Feito de neoprene para o melhor SURF')
      product3 = create(:product, description: 'A história dos primeiros kitesurfistas do mundo')
      product4 = create(:product, description: 'Uma caneca de café')
      
      results = Search.new('surf').inside_products

      expect(results).to include product1
      expect(results).to include product2
      expect(results).to include product3
      expect(results).not_to include product4
    end

    it 'should find products by brand, regardless of letter case' do
      product1 = create(:product, brand: 'Surf Maravilha')
      product2 = create(:product, brand: 'SURF me')
      product3 = create(:product, brand: 'editora amigos do surf')
      product4 = create(:product, brand: 'TOC & ex-TOC')
      
      results = Search.new('surf').inside_products

      expect(results).to include product1
      expect(results).to include product2
      expect(results).to include product3
      expect(results).not_to include product4
    end

    it 'should find products by SKU, regardless of letter case' do
      product3 = create(:product, sku: 'SURF32543')
      product4 = create(:product, sku: 'CANECA998')
      
      results = Search.new('surf').inside_products

      expect(results).to include product3
      expect(results).not_to include product4
    end

    it 'should find products regardless of their status' do
      product1 = create(:product, status: 'off_shelf',name: 'Malucos do kitesurf')
      product2 = create(:product, status: 'draft',    description: 'Prancha para surfar')
      product3 = create(:product, status: 'on_shelf', brand: 'Surf Maravilha')
      product4 = create(:product, status: 'on_shelf', sku: 'SURF32543')
      product5 = create(:product, status: 'on_shelf', name: 'Caneca de café')
      
      results = Search.new('surf').inside_products

      expect(results).to include product1
      expect(results).to include product2
      expect(results).to include product3
      expect(results).to include product4
      expect(results).not_to include product5
    end

    it 'should work for expressions' do
      product1 = create(:product, name: 'Café com caneca de brinde')
      product2 = create(:product, name: 'Caneca Mon Amour com pires')
      
      results = Search.new('"com caneca"').inside_products

      expect(results).to include product1
      expect(results).not_to include product2
    end

    it 'should work for multiple keywords' do
      product1 = create(:product, description: 'short')
      product2 = create(:product, description: 'neoprene')
      product3 = create(:product, description: 'short em neoprene')
      product4 = create(:product, description: 'Uma caneca de café')
      
      results = Search.new('short neoprene').inside_products

      expect(results).to include product1
      expect(results).to include product2
      expect(results).to include product3
      expect(results).not_to include product4
    end

    it 'should work for multiple keywords and phrases together' do
      product1 = create(:product, description: 'short em tactel para surfar')
      product2 = create(:product, description: 'surf')
      product3 = create(:product, description: 'short em neoprene para kitesurf')
      product4 = create(:product, description: 'Uma caneca de café')
      
      results = Search.new('surf "short em"').inside_products

      expect(results).to include product1
      expect(results).to include product2
      expect(results).to include product3
      expect(results).not_to include product4
    end
  end
end
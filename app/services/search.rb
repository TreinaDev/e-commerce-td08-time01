class Search < ApplicationService 
  attr_reader :query, :original_query

  def initialize(query)
    @original_query = query + '' # the addition forces saving a copy
    @query = sanitize_query(query)
  end

  def inside_products
    keywords = self.split_keywords
    products = keywords.reduce([]) { |memo, query|
      query = '%' + query + '%'
      memo << Product.where('name LIKE ?', query)
      memo << Product.where('description LIKE ?', query)
      memo << Product.where('brand LIKE ?', query)
      memo << Product.where('sku LIKE ?', query)
    }.flatten.uniq.sort_by(&:name)
  end

  def sanitize_query(str)
    str.gsub!('%', '')
    str.scan(/\S+_\S+/).each { |connected_word| str.gsub!(connected_word, '"' + connected_word + '"')}
    str.gsub!('_', ' ') 
    @query = str
  end

  def split_keywords
    query = @query + '' # the addition forces a copy of @query
    phrases = query.scan(/"([^"]*)"/).flatten
    phrases.each do |phrase|
      query.gsub!('"' + phrase + '"', '') # temporarily remove phrases
    end
    single_keywords = query.split
    single_keywords + phrases
  end
end

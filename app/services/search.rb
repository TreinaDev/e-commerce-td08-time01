class Search < ApplicationService 
  def self.products(query)
    sanitized_and_split_query_array = Product.sanitize_sql_like(query).split.map { |keyword| '%' + keyword + '%' }
    @products = sanitized_and_split_query_array.reduce([]) { |memo, query|
                memo << Product.where('name LIKE ?', query)
                memo << Product.where('description LIKE ?', query)
                memo << Product.where('brand LIKE ?', query)
                memo << Product.where('sku LIKE ?', query)
    }.flatten
  end
end
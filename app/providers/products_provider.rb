class ProductsProvider
  attr_reader :results

  def initialize(key)
    @results = Product.all
    filter_by_key(key)
  end

  def filter_by_key(key)
    @results = if key.blank?
                 []
               else
                 @results.where('lower(name) like ?', "%#{key[:key].downcase}%")
               end
  end
end

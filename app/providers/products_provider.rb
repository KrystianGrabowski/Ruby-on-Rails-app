# Provider/dostawca produktów
class ProductsProvider
  attr_reader :results

  # Inicializacja względem klucza
  def initialize(key)
    @results = Product.all
    filter_by_key(key)
  end

  # Filtrowanie produktów względem klucza (wyszukiwania)
  def filter_by_key(key)
    @results = if key.nil? || (key == '')
                 @results
               else
                 @results.search(key)
               end
  end
end

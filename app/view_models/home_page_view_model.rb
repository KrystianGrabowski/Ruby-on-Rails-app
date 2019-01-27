# ViedModel produktów umożliwiający pokazanie wybranych produktów jako wyróżnione
class HomePageViewModel
  # Promowany (bo najnowszy) produkt
  def featured_product
    Product.last
  end

  # 3 najnowsze produkty (poza promowanym)
  def new_products
    featured_product.nil? ? [] : Product.where.not(id: featured_product.id).order('created_at desc').first(3)
  end

  # 3 najbardziej popularne produkty (względem ilości komentarzy)
  def popular_products
    Product.left_joins(:comments).group(:product_id, :id).order('count(product_id) desc, created_at desc').limit(3)
  end
end

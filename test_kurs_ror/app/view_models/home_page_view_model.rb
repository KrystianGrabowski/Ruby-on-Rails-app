class HomePageViewModel

  def featured_product
    Product.last
  end

  def new_products
    Product.where.not(id: featured_product.id).last(3)
  end

  def pupular_products
    Product.joins(:comments).group(:product_id, :id).order('count(product_id) desc').limit(3)
  end

end

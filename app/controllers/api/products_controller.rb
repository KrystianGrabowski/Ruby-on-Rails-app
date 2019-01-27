# API do produktów
module Api
  class ProductsController < ApplicationController
    # Provider do produktów (wyszukiwanych)
    def index
      provider = ProductsProvider.new(params[:key])
      render json: provider.results
    end
  end
end

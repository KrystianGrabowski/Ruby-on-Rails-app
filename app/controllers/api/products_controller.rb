module Api
  class ProductsController < ApplicationController
    def index
      provider = ProductsProvider.new(key: params[:key])
      render json: provider.results
    end
  end
end

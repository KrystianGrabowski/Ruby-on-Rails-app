module Api
  class UsersController < ApplicationController
    def email_exists
      render json: User.where(email: params[:email]).exists?
    end
  end
end

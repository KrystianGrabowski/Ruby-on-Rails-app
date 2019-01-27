# API użytkowników
module Api
  class UsersController < ApplicationController
    # Sprawdzenie czy email już istnieje w bazie
    def email_exists
      render json: User.where(email: params[:email]).exists?
    end

    # Sprawdzenie czy email jest poprawny
    def email_correct
      # render json: !/^[0-9a-zA-Z_.-]+@[0-9a-zA-Z.-]+\.[a-zA-Z]{2,3}$/.match(params[:email]).nil?
      render json: !Devise.email_regexp.match(params[:email]).nil?
    end
  end
end

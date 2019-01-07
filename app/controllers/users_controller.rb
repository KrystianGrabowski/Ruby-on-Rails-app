class UsersController < ApplicationController
  before_action :authenticate_admin_user!, except: %i[show edit update user_params]
  before_action :correct_user, only: %i[edit update user_params]
  add_breadcrumb 'Users', :users_path
  def show
    @user = User.find(params[:id])
    add_breadcrumb @user.display_name.to_s, :user_path
    @comments = @user.comments.sort.group_by(&:product)
  end

  def edit
    @user = User.find(params[:id])
    add_breadcrumb @user.display_name.to_s, :user_path
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path
    flash[:notice] = 'Edytowano profil!'
  end

  def user_params
    params.require(:user).permit!
  end

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    return unless @user.destroy

    redirect_to users_index_path
    flash[:notice] = 'Usunięto użytkownika!'
  end

  private

  def correct_user
    if user_signed_in?
      return true if current_user.id.to_s == params[:id]
    end
    flash[:notice] = 'Niedozwolona operacja!'
    redirect_to products_path
    false
  end
end

class UsersController < ApplicationController
  before_action :authenticate_admin_user!, except: %i[show edit]
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
end

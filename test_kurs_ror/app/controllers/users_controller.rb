class UsersController < ApplicationController
  before_action :authenticate_admin_user!,  except: %i[show]

  def show 
    @user = User.find(params[:id])
    @comments = Comment.all.find_all{|c| c.user_id == @user.id}.sort.group_by{|c| c.product}

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

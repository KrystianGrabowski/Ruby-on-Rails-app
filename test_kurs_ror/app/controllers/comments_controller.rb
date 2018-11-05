class CommentsController < ApplicationController
  before_action :authenticate_admin_user!, only: %i[destroy]
  def create
    @comment = Comment.new(params.require(:comment).permit(:content, :product_id).merge(user_id: !current_user ? nil : current_user.id))
    flash[:notice] = if @comment.save
                       'Komentarz został dodany'
                     else
                       @comment.errors.full_messages.join('. ')
                     end
    redirect_to @comment.product
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_back(fallback_location: root_path)
    flash[:notice] = 'Comment was destroyed!'
  end
end

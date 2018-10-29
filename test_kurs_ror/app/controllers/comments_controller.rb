class CommentsController < ApplicationController
  def create
    @comment = Comment.new(params.require(:comment).permit(:content, :product_id))
    if @comment.save
      flash[:notice] = 'Komentarz został dodany'
      redirect_to @comment.product
    else
      flash[:notice] = @comment.errors.full_messages.join('. ')
      redirect_to @comment.product
    end
  end
end

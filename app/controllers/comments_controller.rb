# Kontroler odpowiedzialny za komentarze pod produktami
class CommentsController < ApplicationController
  # Wymóg logowania przed akcjami administracji
  before_action :authenticate_admin_user!, only: %i[destroy undo_report]

  # Utworzenie komentarza (automatycznie przypisuje akutalnie zalogowanego użytkownika do komentarza)
  def create
    @comment = Comment.new(params.require(:comment).permit(:content, :product_id).merge(user: current_user))
    flash[:notice] = if @comment.save
                       'Komentarz został dodany'
                     else
                       @comment.errors.full_messages.join('. ')
                     end
    redirect_to @comment.product
  end

  # Usunięcie komentarza przez admina
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_back(fallback_location: root_path)
    flash[:notice] = 'Comment was destroyed!'
  end

  # Oznaczenie komentarza jako zareportowanego - do późniejszej moderacji przed admina strony
  def report
    @comment = Comment.find(params[:id])
    @comment.update review_request: true
    redirect_to @comment.product
    flash[:notice] = 'Comment reported!'
  end

  # Usunięcie oznaczenia komentarza jako zareportowanego
  def undo_report
    @comment = Comment.find(params[:id])
    @comment.update review_request: false
    redirect_to comments_reported_path
    flash[:notice] = 'Request rejected!'
  end

  # Dostęp do wszystkich oznaczonych komentarzy
  def reported
    @reported_comments = Comment.where(review_request: true)
    add_breadcrumb 'Reported comments', comments_reported_path
  end

  private

  def set_user_id
    !current_user ? nil : current_user.id
  end
end

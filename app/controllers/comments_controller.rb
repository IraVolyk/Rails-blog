class CommentsController < ApplicationController
  before_action :correct_user,   only: :destroy

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    redirect_to article_path(@article)
  end
  
  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to @article
  end
 
  private
    def comment_params
      params.require(:comment).permit(:body)
    end

    def correct_user
      if !current_user.admin?
        @article = Article.find(params[:article_id])
        @comment = @article.comments.find(params[:id])
        redirect_to(root_url) unless current_user?(@comment.user)
      end
    end
end
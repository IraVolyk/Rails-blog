class CommentsController < ApplicationController
  before_action :find_article!, only: [:create, :destroy]
  before_action :correct_user, only:  [:destroy]
  before_action :find_commentable

  def create
    @comment = @commentable.comments.create(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    redirect_to article_path(@article)
  end
  
  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy
    redirect_to @article
  end
 
  private

    def find_article!
      @article = Article.find(params[:article_id)
    end

    def find_commentable
      @commentable = Article.find_by_id(params[:article_id]) if params[:article_id]
      @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
    end

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
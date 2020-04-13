class ArticlesController < ApplicationController
  before_action :find_article!, only: [:show, :edit,:update, :destroy]
	before_action :correct_user, only:  [:edit, :update, :destroy]

  def index
    @articles = Article.includes(:user).paginate(page: params[:page], per_page: 10)
    if params.has_key? :search
      @search = params[:search]
      @articles = @articles.where("title like ?", "%#{@search}%")
    end
  end

	def show
    @comments = @article.comments.includes(:comments, :user).paginate(page: params[:page], per_page: 3)
  end

	def new
    @article = Article.new
	end

  def edit
  end

	def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end
  
  def update
    flash[:success] = "Successfully updated!"
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    if @article.destroy
      flash[:success] = "Successfully deleted!"
      redirect_to @article
    else
      flash[:error] = "Something went wrong, the acticle wasn't deleted"
    end
  end

  private
  
    def find_article!
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :text)
    end

    def correct_user
      if !current_user.admin?
        @article = Article.find(params[:id])
        redirect_to(root_url) unless current_user?(@article.user)
      end
    end
end

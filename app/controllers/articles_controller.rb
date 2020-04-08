class ArticlesController < ApplicationController
	before_action :correct_user, only:  [:edit, :update, :destroy]

  def index
    if params.has_key? :search
      @search = params[:search]
      @articles = Article.where("title like ?", "%#{@search}%")
    else
      @articles = Article.all
    end
  end

	def show
    @article = Article.find(params[:id])
  end

	def new
    @article = Article.new
	end

  def edit
    @article = Article.find(params[:id])
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
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.destroy
      flash[:success] = "Successfully deleted!"
      redirect_to @article
    else
      render 'edit'
    end
  end

  private
  
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

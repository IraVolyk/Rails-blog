class ArticlesController < ApplicationController
	http_basic_authenticate_with name: "dhh", password: "secret", 
  except: [:index, :show]

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
    if @article.destroy(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  private
  
    def article_params
      params.require(:article).permit(:title, :text)
    end
end

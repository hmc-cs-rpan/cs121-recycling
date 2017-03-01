class ArticleController < ApplicationController
  def index
  	@articles = Article.all
  end

  def show
  	@article = Article.find(params[:id])
  end

  def new
  	@article = Article.new
  end

  def create
  	@article = Article.new(article_params)
  	if @article.save
  		flash[:success] = "Success!"
  		redirect_to article_path(@article)
  	else
  		flash[:error] = @article.errors.full_messages
  		redirect_to new_article_path
  	end
  end



  def edit
  end

  def update
  end

  def delete
  end

  def article_params
  	params.require(:article).permit(:title, :content, :image, :description)
  end

end

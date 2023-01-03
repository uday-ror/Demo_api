class ArticlesController < ApplicationController
  before_action :authorize_request
  before_action :set_article, only: [:update, :show, :destroy]

  def index
    # byebug
    @articles = @current_user.articles
    #byebug
    render json: @articles, each_serializer: ArticleSerializer, status: :ok
  end

  def create
    # byebug
    article = @current_user.articles.new(article_params)
    if article.save
      render json: ArticleSerializer.new(article).serializable_hash, status: :created
    else
      render json: article.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @article, each_serializer: ArticleSerializer, status: :ok
  end

  def update
    if @article.update(article_params) 
      render json: @article, each_serializer: ArticleSerializer, status: :ok
    else
      render json: @article.errors
    end
  end

  def destroy
    #byebug
    if @article.destroy
      render json: {message: 'Article of Current User Delete Succesfully'}, status: :ok
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  private

  def set_article
    #byebug
    @article = @current_user.articles.find_by_id(params[:id])
    render json: {message: 'Article Not Found'} unless @article.present?
  end


  def article_params
    # byebug
    params.require(:article).permit(:title, :body)
  end
end


# index = show all articles of current_user
# show = if find article belongs to current_user then it will show
# delete = if find article belongs to current_user then it will delete
# update = if find article belongs to current_user then it will show

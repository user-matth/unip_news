class ArticlesController < ApplicationController
  include Paginable

  before_action :authenticate_user!, except: %i[ index show ]
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @categories = Category.sorted
    category = @categories.select { |i| i.name == params[:category] }[0] if params[:category].present?
    
    @highlights = Article.includes(:category, :user).filter_by_category(category).desc_order.first(3)
    highlights_ids = @highlights.pluck(:id).join(',')

    @articles = Article.includes(:category, :user).filter_by_category(category).without_highlights(highlights_ids).desc_order.page(current_page)
  end

  def show; end

  def new
    @article = current_user.articles.new
  end

  def create
    @article = current_user.articles.new(article_params)

    if @article.save 
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new
    end
  end

  def edit; end
  
  def update

    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      render :new
    end
  end

  def destroy
    @article.destroy

    redirect_to root_path, notice: "Article was successfully destroyed."
  end

  private 

  def article_params
    params.require(:article).permit(:title, :body, :category_id)
  end

  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end

end

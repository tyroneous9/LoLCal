class ArticlesController < ApplicationController
  def index
    # fetch all articles from the database
    @articles = Article.all
  end
end

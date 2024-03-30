class ArticlesController < ApplicationController
  def index
    # fetch all articles from the database
    @items = Item.all
    @build_items = BuildItem.all
  end
end

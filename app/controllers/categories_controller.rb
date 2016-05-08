class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @feeds = @category.feeds
    @entries = @category.entries.paginate(:page => params[:page], :per_page => 10)
  end
end

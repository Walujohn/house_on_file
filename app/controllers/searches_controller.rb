class SearchesController < ApplicationController
  def index
    @spaces = Space.containing(params[:query])
  end
end

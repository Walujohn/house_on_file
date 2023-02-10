class SearchesController < ApplicationController
  before_action :set_property
    
  def index
#    templates
    @names = @property.list_of_space_names.select { |name| name == params[:query] }
      
#    user created from the db
#    @spaces = Space.containing(params[:query])
      
    @space = @property.spaces.build
      
    if params[:location] == "List exteriors"
      @space.location = "exterior"
    end
  end
    
  private

  def set_property
    @property = current_group.properties.find(params[:property_id])
  end
end

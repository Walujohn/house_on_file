class SearchesController < ApplicationController
  before_action :set_property
    
  def index
#    templates
    if @property.list_of_interior_space_names.select { |name| name == params[:query] }.present? 
      @space = @property.spaces.build(location: "interior")
      @space_names = @property.list_of_interior_space_names.select { |name| name == params[:query] }
    elsif @property.list_of_exterior_space_names.select { |name| name == params[:query] }.present?
      @space = @property.spaces.build(location: "exterior")
      @space_names = @property.list_of_exterior_space_names.select { |name| name == params[:query] }
    elsif @property.list_of_appliance_names.select { |name| name == params[:query] }.present? 
      @appliance_names = @property.list_of_appliance_names.select { |name| name == params[:query] }
      @appliance = @property.appliances.build
    elsif @property.shut_off_locations.select { |name| name == params[:query] }.present?
      @appliance_names = @property.shut_off_locations.select { |name| name == params[:query] }
      @appliance = @property.appliances.build
    end
#    user created from the db
#    @spaces = Space.containing(params[:query])      
  end
    
  private

  def set_property
    @property = current_group.properties.find(params[:property_id])
  end
end

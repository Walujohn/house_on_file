class PropertiesController < ApplicationController
    before_action :set_property, only: [:show, :edit, :update, :destroy]
    before_action :set_space, only: [:show]
    before_action :set_came_from_new_create, only: [:new, :create]

    def index
      @properties = current_group.properties.ordered.reverse
    end

    def show   
      if @dropdown_name = params.dig(:property, :name)
        if @dropdown_name == "List interiors" 
          @spaces = @property.spaces.includes(:features).ordered.where(location: "interior")
        elsif @dropdown_name == "List exteriors"
          @spaces = @property.spaces.includes(:features).ordered.where(location: "exterior")
        elsif @dropdown_name == "List all"
          @spaces = @property.spaces.includes(:features).ordered
        elsif @dropdown_name == "List appliances"
          @spaces = @property.spaces.includes(:features).ordered
        elsif @dropdown_name == "New spaces table"   
          @spaces = @property.spaces.includes(:features).ordered
          @names = @property.list_of_space_names
          @lettered_names = @names.group_by { |name| name[0].to_sym } 
          @space = @property.spaces.build 
        elsif @dropdown_name == "Interior spaces table"
          @spaces = @property.spaces.includes(:features).ordered.where(location: "interior")
          @names = @property.list_of_interior_space_names
          @lettered_names = @names.group_by { |name| name[0].to_sym } 
          @space = @property.spaces.build(location: "interior")
        elsif @dropdown_name == "Exterior spaces table"
          @spaces = @property.spaces.includes(:features).ordered.where(location: "exterior")
          @names = @property.list_of_exterior_space_names
          @lettered_names = @names.group_by { |name| name[0].to_sym } 
          @space = @property.spaces.build(location: "exterior")
        elsif @dropdown_name == "Interior spaces table w/ features"
          @spaces = @property.spaces.includes(:features).ordered.where(location: "interior")
          @names = @property.list_of_interior_space_names
          @lettered_names = @names.group_by { |name| name[0].to_sym } 
          @space = @property.spaces.build(location: "interior") 
        elsif @dropdown_name == "Exterior spaces table w/ features"
          @spaces = @property.spaces.includes(:features).ordered.where(location: "exterior")
          @names = @property.list_of_exterior_space_names
          @lettered_names = @names.group_by { |name| name[0].to_sym } 
          @space = @property.spaces.build(location: "exterior")
        elsif @dropdown_name == "New appliances table"
          @spaces = @property.spaces.includes(:features).ordered
          @names = @property.list_of_appliance_names
          @lettered_names = @names.group_by { |name| name[0].to_sym } 
          @appliance = @property.appliances.build 
        elsif @dropdown_name == "Shut off locations"
          @spaces = @property.spaces.includes(:features).ordered
          @names = @property.shut_off_locations
          @lettered_names = @names.group_by { |name| name[0].to_sym } 
          @appliance = @property.appliances.build 
        else
          @model_creations = @property.respond_to_dropdown(@dropdown_name, current_group)
          @spaces = @property.spaces.includes(:features).ordered
        end
        @appliances = @property.appliances.includes(:appliance_features).ordered
      else
        @spaces = @property.spaces.includes(:features).ordered
        @appliances = @property.appliances.includes(:appliance_features).ordered    
      end 

      respond_to do |format|
        format.html
        format.pdf do # wicked_pdf gem
          render pdf: "file_name", # Excluding ".pdf" extension
          template: "properties/report",
          formats: [:html],
          layout: "pdf"
#         page_size: 'A4',
#         orientation: "Landscape",
#         lowquality: true,
#         zoom: 1,
#         dpi: 75
        end
      end
    end

    def new
#     @property = Property.new
      @property = Property.new property_params   
    end

    def create
      @property = current_group.properties.build(property_params)
      if @property.save
        if params.dig(:property, :style) == "Town houses, shared, apartments" or params.dig(:property, :style) == "no" or params.dig(:property, :style) == "yes"
          @property.build(property_params, current_group)
          @properties = current_group.properties.ordered.reverse
        end
        respond_to do |format|
          format.html { redirect_to properties_path, notice: "Property was successfully created." }
          format.turbo_stream { flash.now[:notice] = "Property was successfully created." }
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit  
    end

    def update
      if @property.update(property_params)
          
        respond_to do |format|
          format.html { redirect_to properties_path, notice: "Property was successfully updated." }
          format.turbo_stream { flash.now[:notice] = "Property was successfully updated." }
        end
      else
        render :edit, status: :unprocessable_entity
      end    
    end

    def destroy
      if @property.property_template and @property.property_template.to_i != 0
        @associated_property = current_group.properties.where(id: @property.property_template.to_i).first
      end
      @property.destroy
        
      respond_to do |format|
        format.html { redirect_to properties_path, notice: "Property was successfully destroyed." }
        format.turbo_stream { flash.now[:notice] = "Property was successfully destroyed." }
      end
    end

    private

    def set_property
      @property = current_group.properties.find(params[:id])
    end
    
    def set_space
      @space = @property.spaces.build
    end
    
    def set_came_from_new_create
      @came_from_new_create = "yes"
    end

    def property_params
#     params.require(:property).permit(:name)
      params.fetch(:property, {}).permit(:name, :style, :letter, :low, 
                                         :high, :address, :addresstwo, 
                                         :city, :state, :country, :yearbuilt, 
                                         :squarefootage, :lotsize, :zip, 
                                         :interval, :exclusion, :property_template)
    end
end

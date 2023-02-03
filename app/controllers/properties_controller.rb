class PropertiesController < ApplicationController
    before_action :set_property, only: [:show, :edit, :update, :destroy]
    before_action :set_space, only: [:show]
    before_action :set_came_from_new_create, only: [:new, :create]
    before_action :set_names, only: [:show]
    before_action :set_lettered_names, only: [:show]
  
    def index
      @properties = current_group.properties.ordered
    end

    def show   
      if @dropdown_name = params.dig(:property, :name)
        if @dropdown_name == "List interiors" 
          @spaces = @property.spaces.includes(:features).ordered.where(location: "interior")
        elsif @dropdown_name == "List exteriors"
          @spaces = @property.spaces.includes(:features).ordered.where(location: "exterior")
        elsif @dropdown_name == "Draw"
          @spaces = @property.spaces.includes(:features).ordered
        else
          @property.respond_to_dropdown(@dropdown_name, current_group)
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
        if params.dig(:property, :style) == "Town houses, shared, apartments"
          @property.build(property_params, current_group)
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
    
    def set_names
      @names = @property.list_of_space_names
    end
  
    def set_lettered_names 
      @lettered_names = @names.group_by { |name| name[0].to_sym } 
    end

    def property_params
#     params.require(:property).permit(:name)
      params.fetch(:property, {}).permit(:name, :style, :letter, :low, 
                                         :high, :address, :addresstwo, 
                                         :city, :state, :country, :yearbuilt, 
                                         :squarefootage, :lotsize, :zip, :property_template)
    end
end

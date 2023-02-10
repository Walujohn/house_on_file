class SpacesController < ApplicationController
  before_action :set_property
  before_action :set_space, only: [:edit, :update, :destroy]
  before_action :set_names, only: [:new]
  before_action :set_lettered_names, only: [:new]
  
  def new
    @space = @property.spaces.build
    if params[:location] == "List exteriors"
      @space.location = "exterior"
    end
  end

  def create  
    @space = @property.spaces.build(space_params)
    @space.number_the_name(@property)
    if @space.save
      @property.respond_to_alternative_space_create_params(params, @space, current_group, current_user, space_params)
      if params[:location] == "List interiors"
        @spaces = @property.spaces.includes(:features).ordered.where(location: "interior")
      elsif params[:location] == "List exteriors"
        @spaces = @property.spaces.includes(:features).ordered.where(location: "exterior")
      else
        @spaces = @property.spaces.includes(:features).ordered
      end
        
      respond_to do |format|
        format.html { redirect_to property_path(@property), notice: "Space was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Space was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
    
  def edit
  end

  def update  
    if params[:previous_space_id]
      @space = @property.spaces.build(space_params)
      @previous_space = @property.spaces.find(params[:previous_space_id])
      if @space.save  
        @property.respond_to_alternative_space_update_params(@space, @previous_space, current_group, current_user)
          
        respond_to do |format|
          format.html { redirect_to property_path(@property), notice: "Space was successfully created." }
          format.turbo_stream { flash.now[:notice] = "Space was successfully created." }
        end
      else
        render :new, status: :unprocessable_entity
      end
    else  
      if @space.update(space_params)
        if @property.property_template and @property.property_template.to_i == 0
          @property.hand_down_update_space(current_group, @space, current_user)
        end
          
        respond_to do |format|
          format.html { redirect_to property_path(@property), notice: "Space was successfully updated." }
          format.turbo_stream { flash.now[:notice] = "Space was successfully updated." }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end  
  end
    
  def destroy
    if @property.property_template and @property.property_template.to_i == 0
      @property.hand_down_destroy_space(current_group, @space)
    end
    @space.destroy
      
    respond_to do |format|
      format.html { redirect_to property_path(@property), notice: "Space was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Space was successfully destroyed." }
    end
  end

  private

  def space_params
    params.require(:space).permit(:name, :location, :user_id)
  end

  def set_property
    @property = current_group.properties.find(params[:property_id])
  end
    
  def set_space
    @space = @property.spaces.find(params[:id])
  end

  def set_names
    @names = @property.list_of_space_names
  end
  
  def set_lettered_names 
    @lettered_names = @names.group_by { |name| name[0].to_sym } 
  end
end









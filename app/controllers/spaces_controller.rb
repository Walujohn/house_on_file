class SpacesController < ApplicationController
  before_action :set_property
  before_action :set_space, only: [:edit, :update, :destroy]
  
  def new
    @space = @property.spaces.build
    if params[:location] and params[:location] == "List exteriors"
      @space.location = "exterior"
    end
  end

  def create  
    @space = @property.spaces.build(space_params)
    @space.number_the_name(@property)

    if @space.save
      if @property.property_template and @property.property_template.to_i == 0
        @property.hand_down_space(current_group, @space, current_user)
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
        @previous_space.duplicate_features(@space) unless @previous_space.features.empty?
#        then check to see if this is an 'apartment' template property doing this
        if @property.property_template and @property.property_template.to_i == 0
          @property.hand_down_duplicate_space_with_features(current_group, @space, current_user)
        end
          
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
end









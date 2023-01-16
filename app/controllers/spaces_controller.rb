class SpacesController < ApplicationController
  before_action :set_property
  before_action :set_space, only: [:edit, :update, :destroy]

  def new
    @space = @property.spaces.build
  end

  def create
    @space = @property.spaces.build(space_params)
      
    if @space.save
      if params[:old_space]
        @previous_space = @property.spaces.find(params[:old_space])
        duplicate_features(@previous_space, @space)
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
    if @space.update(space_params)
      respond_to do |format|
        format.html { redirect_to property_path(@property), notice: "Space was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Space was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end    
    
  def destroy
      @space.destroy
      respond_to do |format|
          format.html { redirect_to property_path(@property), notice: "Space was successfully destroyed." }
          format.turbo_stream { flash.now[:notice] = "Space was successfully destroyed." }
      end
  end
    
  def duplicate_features(previous_space, space)
    previous_space.features.each do |f|
      space.features.build(id: self,
                           name: f.name, 
                           variety: f.variety, 
                           description: f.description)
    end
    space = space.save
  end

  private

  def space_params
    params.require(:space).permit(:name)
  end

  def set_property
    @property = current_group.properties.find(params[:property_id])
  end
    
  def set_space
    @space = @property.spaces.find(params[:id])
  end
end

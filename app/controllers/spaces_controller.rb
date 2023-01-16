class SpacesController < ApplicationController
  before_action :set_property
  before_action :set_space, only: [:edit, :update, :destroy]
  before_action :set_first_space, only: [:new, :create, :update] 
  before_action :set_other_space, only: [:edit]

  def new
    @space = @property.spaces.build
  end

  def create
    @space = @property.spaces.build(space_params)

    if @space.save
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
    
  def set_first_space
    @first_space = params[:first_space] or @first_space = params.dig(:space, :first_space)
  end
    
  def set_other_space
    @other_space = params[:other_space]
  end
end

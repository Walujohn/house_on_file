class FeaturesController < ApplicationController
  before_action :set_property
  before_action :set_space
  before_action :set_feature, only: [:edit, :update, :destroy]

  def new
    @feature = @space.features.build
  end

  def create
    @feature = @space.features.build(feature_params)

    if @feature.save
        respond_to do |format|
            format.html { redirect_to property_path(@property), notice: "Feature was successfully created." }
            format.turbo_stream { flash.now[:notice] = "Feature was successfully created." }
        end
    else
        render :new, status: :unprocessable_entity
    end
  end
    
  def edit
  end

  def update
    if @feature.update(feature_params)
        respond_to do |format|
          format.html { redirect_to property_path(@property), notice: "Feature was successfully updated." }
          format.turbo_stream { flash.now[:notice] = "Feature was successfully updated." }
        end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to property_path(@property), notice: "Feature was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Feature was successfully destroyed." }
    end
  end    

  private

  def feature_params
    params.require(:feature).permit(:name, :description, :quantity, :unit_price)
  end

  def set_property
    @property = current_group.properties.find(params[:property_id])
  end

  def set_space
    @space = @property.spaces.find(params[:space_id])
  end
    
  def set_feature
    @feature = @space.features.find(params[:id])
  end
    
end

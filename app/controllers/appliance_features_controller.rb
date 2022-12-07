class ApplianceFeaturesController < ApplicationController
  before_action :set_property
  before_action :set_appliance
  before_action :set_feature, only: [:edit, :update, :destroy]

  def new
    @appliance_feature = @appliance.appliance_features.build
  end

  def create
    @appliance_feature = @appliance.appliance_features.build(feature_params)

    if @appliance_feature.save
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
    if @appliance_feature.update(feature_params)
        respond_to do |format|
          format.html { redirect_to property_path(@property), notice: "Feature was successfully updated." }
          format.turbo_stream { flash.now[:notice] = "Feature was successfully updated." }
        end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @appliance_feature.destroy

    respond_to do |format|
      format.html { redirect_to property_path(@property), notice: "Feature was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Feature was successfully destroyed." }
    end
  end    

  private

  def feature_params
    params.require(:appliance_feature).permit(:name, :description, :quantity, :unit_price)
  end

  def set_property
    @property = current_group.properties.find(params[:property_id])
  end

  def set_appliance
    @appliance = @property.appliances.find(params[:appliance_id])
  end
    
  def set_feature
    @appliance_feature = @appliance.appliance_features.find(params[:id])
  end    
end

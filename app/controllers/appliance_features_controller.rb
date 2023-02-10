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
      if @property.property_template and @property.property_template.to_i == 0
        @property.hand_down_appliance_feature(current_group, @appliance, @appliance_feature, current_user)
      end
#     so this space cannot be destroyed by reset canvas if its features are edited
      @appliance.update(user_id: current_user.id)  
        
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
      if @property.property_template and @property.property_template.to_i == 0
        @property.hand_down_appliance_feature_update(current_group, @appliance_feature, current_user)
      end
#     so this space cannot be destroyed by reset canvas if its features are edited
      @appliance.update(user_id: current_user.id)
        
      respond_to do |format|
        format.html { redirect_to property_path(@property), notice: "Feature was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Feature was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @property.property_template and @property.property_template.to_i == 0
      @property.hand_down_appliance_feature_destroy(current_group, @appliance_feature)
    end 
    @appliance_feature.destroy
#   so this space cannot be destroyed by reset canvas if its features are edited
    @appliance.update(user_id: current_user.id)
      
    respond_to do |format|
      format.html { redirect_to property_path(@property), notice: "Feature was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Feature was successfully destroyed." }
    end
  end    

  private

  def feature_params
    params.require(:appliance_feature).permit(:name, :description, :quantity, :unit_price, :user_id)
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

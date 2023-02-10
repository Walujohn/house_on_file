class AppliancesController < ApplicationController
  before_action :set_property
  before_action :set_appliance, only: [:edit, :update, :destroy]

  def new
    @appliance = @property.appliances.build
  end

  def create
    @appliance = @property.appliances.build(appliance_params)

    if @appliance.save
      if @property.property_template and @property.property_template.to_i == 0
        @property.hand_down_appliance(current_group, @appliance, current_user)
      end
      respond_to do |format|
        format.html { redirect_to property_path(@property), notice: "Appliance was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Appliance was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
    
  def edit
  end

  def update
    if @appliance.update(appliance_params)
      if @property.property_template and @property.property_template.to_i == 0
        @property.hand_down_appliance_update(current_group, @appliance, current_user)
      end
      respond_to do |format|
        format.html { redirect_to property_path(@property), notice: "Appliance was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Appliance was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end    
    
  def destroy
      if @property.property_template and @property.property_template.to_i == 0
        @property.hand_down_destroy_appliance(current_group, @appliance)
      end
      @appliance.destroy
      
      respond_to do |format|
          format.html { redirect_to property_path(@property), notice: "Appliance was successfully destroyed." }
          format.turbo_stream { flash.now[:notice] = "Appliance was successfully destroyed." }
      end
  end

  private

  def appliance_params
    params.require(:appliance).permit(:name, :user_id)
  end

  def set_property
    @property = current_group.properties.find(params[:property_id])
  end
    
  def set_appliance
    @appliance = @property.appliances.find(params[:id])
  end
end

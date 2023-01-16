class FeaturesController < ApplicationController
  before_action :set_property
  before_action :set_space
  before_action :set_feature, only: [:edit, :update, :destroy]
  before_action :rollover_space, only: [:new]
  before_action :set_tab, only: [:new, :create, :edit, :update]
  before_action :set_selected_name, only: [:new, :create, :update]

  def new
#    @feature = @space.features.build
    @feature = @space.features.build(feature_params)
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
#    params.require(:feature).permit(:name, :description, :quantity, :unit_price)
    params.fetch(:feature, {}).permit(:name, :variety, :description, :quantity, :unit_price)
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
 
  def rollover_space
    if params[:rollover] and @space.features.empty?
      @rollover = @property.rollover(@space)
    end
  end
    
  def set_tab
    @tab = params[:tab] or @tab = params.dig(:feature, :tab)
  end
    
  def set_selected_name
    if params[:feature]
      @selected_name = params[:feature][:name]    
    else
#      default
      @selected_name = "wall covering"
    end
  end
end

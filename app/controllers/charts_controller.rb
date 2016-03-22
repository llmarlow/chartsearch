class ChartsController < ApplicationController
  before_action :authenticate_admin!, :except => [:index, :show]
 def index
  @filterrific = initialize_filterrific(
    Chart,
    params[:filterrific]
  ) or return
  @charts = @filterrific.find.page(params[:page])

  respond_to do |format|
    format.html
    format.js
  end
   
   rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end
  
  def show
    @chart = Chart.find(params[:id])
    @tag = @chart.tags.first
  end
  
  def new
    @chart = Chart.new
  end
  
  def edit
    @chart = Chart.find(params[:id])
  end
  
  def update
     @chart = Chart.find(params[:id])
     @chart.update(chart_params)

    redirect_to chart_path(@chart)
  end
  
  def create
    @chart = Chart.new(chart_params)
    @chart.save
    redirect_to chart_path(@chart)
  end
  
  def destroy
    @chart = Chart.find(params[:id])
    @chart.destroy
    
    redirect_to charts_path
  end
  private
  
  def chart_params
    params.require(:chart).permit(:name, :height, :width, :price, :tag_list, :link, :picture, :is_magazine)
  end
end

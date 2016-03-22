class TagsController < ApplicationController
  before_action :authenticate_admin!, :except => [:index, :show]
  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    flash[:notice] = "Tag '#{@tag.name}' destroyed!"
    redirect_to tags_path
  end
end

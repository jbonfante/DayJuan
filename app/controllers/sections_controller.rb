class SectionsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @sections = if params[:keywords]
                 Section.where('name ilike?', "%#{params[:keywords]}%")
               else
                 []
               end
  end

  def show
    @section = Section.find(params[:id])
  end

  def create
    @section = Section.new(params.require(:section).permit(:name, :instructions))
    @section.save
    render 'show', status: 201
  end

  def update
    @section = Section.find(params[:id])
    @section.update_attributes(params.require(:section).permit(:name, :instructions))
    head :no_content
  end

  def destroy
    @section = Section.find(params[:id])
    @section.destroy
    head :no_content
  end
end

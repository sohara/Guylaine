class GalleryController < ApplicationController
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    @galleries = Gallery.find :all
  end
  
  def show
    @gallery = Gallery.find(params[:id])
  end
  
end

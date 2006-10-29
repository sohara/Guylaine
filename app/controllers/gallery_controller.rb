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
  
  def view_image
    @image = Image.find(params[:id])
    render :update do |page|
      page[:box].hide
      page[:innerbox].replace_html :partial => 'gallery/view_image' 
      #page[:box].hide
      page[:overlay].show
      page[:box].setStyle :width => "" + (@image.thumbnails.detect{|t|t.thumbnail == "size800"}.width + 0).to_s + "px"
      page[:box].setStyle :height => "" + (@image.thumbnails.detect{|t|t.thumbnail == "size800"}.height + 30).to_s + "px"
      page << "center('box');"
      page[:box].visual_effect :appear, :duration => 0.5
      #page[:box].show
    end
  end
  
end

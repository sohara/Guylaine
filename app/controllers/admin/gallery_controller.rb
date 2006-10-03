class Admin::GalleryController < ApplicationController
  layout 'admin'
  
  def index
    list
    render :action => 'list'
  end

  def list
    @galleries = Gallery.find :all
  end
  
  def new
    @gallery = Gallery.new
    render :update do |page|
      page[:innerbox].replace_html :partial => 'admin/gallery/new'
      page << "showBox();"
    end
  end
  
  def create
    @gallery = Gallery.new(params[:gallery])
    if @gallery.save
      flash[:notice] = 'Artist was successfully created.'
      render :update do |page|
        page << "hideBox();"
        page.insert_html :top, "gallery_list", :partial => 'admin/gallery/gallery_item'
      end
    else
      render :update do |page|
        page[:innerbox].replace_html :partial => 'admin/gallery/new'
      end
    end
  end
  
  def show
    @gallery = Gallery.find(params[:id])
    @image = Image.new
  end
  
end

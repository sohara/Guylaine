class Admin::GalleryController < Admin::BaseController
  
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
  
  def edit
    @gallery = Gallery.find(params[:id])
    render :update do |page|
      page[:innerbox].replace_html :partial => 'admin/gallery/edit'
      page << "showBox();"
    end
  end
  
  def update
    @gallery = Gallery.find(params[:id])
    unless @gallery.update_attributes(params[:gallery])
      render :update do |page|
        page[:innerbox].replace_html :partial => 'admin/gallery/edit'
      end
    else
      render :update do |page|
        page << "hideBox();"
        page["gallery-data"].replace :partial => 'admin/gallery/show'
        page["gallery-data"].visual_effect :highlight, :startcolor => "#cf2121", :endcolor => "#E8E8E8"
      end
    end
  end
  
  def destroy
    Gallery.find(params[:id]).destroy
    render :update do |page|
      page["gallery_#{params[:id]}"].remove
    end
  end
end

class Admin::ImageController < ApplicationController

  def create
    @gallery = Gallery.find(params[:gallery_id])
    @image = Image.create! params[:image]
    @gallery.images << @image
    flash[:notice] = 'Image added.'
    responds_to_parent do
      render :update do |page|
        page << "UploadProgress.finish();"
        page.insert_html :top, "image_form", '<p style="color:green;">Image uploaded</p>'
        page.insert_html :bottom, 'gallery-image-list', :partial => 'show'
        #Sortable list needs to be reinitialized after adding a new element (image)
        page << "Sortable.create('gallery-image-list', {onUpdate:function(){new Ajax.Request('/admin/image/sort/#{@image.gallery.id}', {asynchronous:true, evalScripts:true, onComplete:function(request){new Effect.Highlight('gallery-image-list',{});}, parameters:Sortable.serialize('gallery-image-list')})}})"
        page["image_#{@image.id}"].visual_effect :highlight, :startcolor => "#cf2121", :endcolor => "#E8E8E8"
      end
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to :controller => 'gallery', :action => 'show', :id => params[:gallery_id]
  end
  
  def edit
    @image = Image.find(params[:id])
    render :update do |page|
      page[:innerbox].replace_html :partial => 'admin/image/edit'
      page << "showBox();"
    end
  end
  
  def update
    @image = Image.find(params[:id])
    logger.info "image title is #{@image.title_en}"
    unless @image.update_attributes(params[:image])
      render :update do |page|
        page[:innerbox].replace_html :partial => 'admin/image/edit'
      end
    else
      render :update do |page|
        page << "hideBox();"
        page["image_#{@image.id}"].replace :partial => 'admin/image/show'
        page["image_#{@image.id}"].visual_effect :highlight, :startcolor => "#cf2121", :endcolor => "#E8E8E8"
      end
    end
  end
  
  def progress
    render :update do |page|
      @status = Mongrel::Uploads.check(params[:upload_id])
      page.upload_progress.update(@status[:size], @status[:received]) if @status
    end
  end
  
  # Method for sortable list functionality for artist_images
  def sort
    @gallery = Gallery.find(params[:id])
    @gallery.images.each do |image|
      image.position = params['gallery-image-list'].index(image.id.to_s) + 1
      image.save
    end
    render :nothing => true
  end
  
  # Destroy an existing tour date
  def destroy
    Image.find(params[:id]).destroy
    render :update do |page|
      page["image_#{params[:id]}"].remove
    end
  end
  
  def view_image
    @image = Image.find(params[:id])
    render :update do |page|
      page[:innerbox].replace_html :partial => 'admin/image/view_image' 
      #page[:box].hide
      page[:overlay].show
      page[:box].setStyle :width => "" + (@image.thumbnails.detect{|t|t.thumbnail == "size800"}.width + 0).to_s + "px"
      page[:box].setStyle :height => "" + (@image.thumbnails.detect{|t|t.thumbnail == "size800"}.height + 0).to_s + "px"
      page << "center('box');"
      page[:box].visual_effect :appear, :duration => 0.5
      #page[:box].show
    end
  end
  
end

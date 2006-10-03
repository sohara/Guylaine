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
      end
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to :controller => 'gallery', :action => 'show', :id => params[:gallery_id]
  end
  
  
  def progress
    render :update do |page|
      @status = Mongrel::Uploads.check(params[:upload_id])
      page.upload_progress.update(@status[:size], @status[:received]) if @status
    end
  end
  
end

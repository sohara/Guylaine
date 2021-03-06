class Image < ActiveRecord::Base
  has_attachment  :storage => :file_system, 
                  :content_type => :image, 
                  :path_prefix  => 'public/uploaded',
                  :thumbnails => { :size800 => '800X800>', 
                    :size250 => '170X170>', 
                    :size96 => '96X96>' },
                  :max_size => 7.megabytes
  validates_as_attachment
#  validates_presence_of :title_en, :title_fr, :message => "must be present"
  after_save :watermark_image 
  belongs_to :gallery
  acts_as_list :scope => :gallery
  
  def watermark_image
    if image?
      unless parent_id.nil?
        dst = Magick::Image.read("#{RAILS_ROOT}/public/#{self.public_filename}").first
        if dst.columns > 250
          src = Magick::Image.read("#{RAILS_ROOT}/public/images/watermark3.png").first
          result = dst.dissolve(src,0.09,1.0, Magick::SouthWestGravity)
          result.write("#{RAILS_ROOT}/public#{self.public_filename}")
        end
      end
    end
  end
  
  # old method for resizing with 95 quality and adding watermark
  # Redefining method in vendor/plugins/acts_as_attachment
  # This redefinition sets the quality to 95 for resized images
  #
  # Sets the actual binary data.  This is typically called by uploaded_data=, but you can call this
  # manually if you're creating from the console.  This is also where the resizing occurs.
  #def attachment_data=(data)
    #logger.info "in attachment_data model method"
    #logger.info "Self is #{self.class}"
    #if data.nil?
      #@attachment_data = nil
      #@save_attachment = false
      #return nil
    #end
    
    #if image?
      #unless parent_id.nil?
        #with_image data do |img|
          #resized_img       = (attachment_options[:resize_to] && parent_id.nil?) ? 
            #thumbnail_for_image(img, attachment_options[:resize_to]) : img
            
            ##if the image is not a thumbnail size then we will add a watermark, but only if it is a public gallery.
            #logger.info "self.parent.gallery.hidden? is #{self.parent.gallery.hidden?}"
            #if resized_img.columns > 250 and self.parent.gallery.hidden? == false
              #mark = Magick::ImageList.new("#{RAILS_ROOT}/public/images/watermark3.png")
              #resized_img = resized_img.dissolve(mark,0.09,1.0,Magick::SouthWestGravity)
            #end
          #data              = resized_img.to_blob { self.quality = 95 }
          #self.width        = resized_img.columns if respond_to?(:width)
          #self.height       = resized_img.rows    if respond_to?(:height)
          #callback_with_args :after_resize, resized_img
        #end
      #else 
        ##this is for images not being thumbnailed (originals)
        #logger.info "data class: #{data.class}"
        #binary_data = Magick::Image::from_blob(data).first
        #self.width = binary_data.columns
        #self.height = binary_data.rows
      #end
    #end
    
    #self.size =  data.length 
    #logger.info "self.size: #{self.size}"
    #@attachment_data = data
    #@save_attachment = true
  #end
  
end

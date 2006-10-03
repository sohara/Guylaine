class Image < ActiveRecord::Base
  acts_as_attachment  :storage => :file_system, 
                      :content_type => :image, 
                      :file_system_path  => 'public/uploaded',
                      :thumbnails => { :size800 => '800>', :size250 => '250>', :size96 => '96>' }
  validates_as_attachment
  belongs_to :gallery

end

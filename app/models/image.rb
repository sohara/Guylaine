class Image < ActiveRecord::Base
  acts_as_attachment  :storage => :file_system, 
                      :content_type => :image, 
                      :file_system_path  => 'public/uploaded',
                      :thumbnails => { :size800 => '800>', :size250 => '250>', :size96 => '96>' },
                      :max_size => 7.megabytes
  validates_as_attachment
#  validates_presence_of :title_en, :title_fr, :message => "must be present"
  
  belongs_to :gallery
  acts_as_list :scope => :gallery
  
end
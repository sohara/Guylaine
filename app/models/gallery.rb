class Gallery < ActiveRecord::Base
  has_many :images, :dependent => :destroy
  validates_presence_of :title_en, :title_fr, :message => "must be present"

end
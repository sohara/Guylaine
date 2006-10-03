class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.column "content_type", :string
      t.column "filename", :string     
      t.column "size", :integer
      t.column "gallery_id", :integer
      # used with thumbnails, always required
      t.column "parent_id",  :integer 
      t.column "thumbnail", :string
      
      # required for images only
      t.column "width", :integer  
      t.column "height", :integer
      
      # fields for descriptions
      t.column "title_en", :string
      t.column "title_fr", :string
      t.column "description_en", :text
      t.column "description_fr", :text
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    # only for db-based files
    # create_table :db_files, :force => true do |t|
    #      t.column :data, :binary
    # end
  end

  def self.down
    drop_table :images
    
    # only for db-based files
    # drop_table :db_files
  end
end

class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      # t.column :name, :string
      t.column "title_en", :string
      t.column "title_fr", :string
      t.column "description_en", :text
      t.column "description_fr", :text
      t.column "created_at", :datetime
    end
  end

  def self.down
    drop_table :galleries
  end
end

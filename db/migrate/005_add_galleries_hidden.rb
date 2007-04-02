class AddGalleriesHidden < ActiveRecord::Migration
  def self.up
    add_column "galleries", "hidden", :boolean, :defaut => 0
  end

  def self.down
    remove_column "galleries", "hidden"
  end
end

class CreateDownloadManagers < ActiveRecord::Migration
  def change
    create_table :download_managers do |t|
      t.text :file_path

      t.timestamps
    end
  end
end

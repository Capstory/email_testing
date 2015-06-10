class AlbumOrder < ActiveRecord::Base
  attr_accessible :address, :contents, :email, :name, :quantities, :total

	serialize :address, JSON
	serialize :contents, JSON
	serialize :quantities, JSON
end

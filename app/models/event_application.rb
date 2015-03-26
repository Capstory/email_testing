class EventApplication < ActiveRecord::Base
  attr_accessible :email, :github_account_name, :language_preference, :name, :student, :university_year, :work_preference, :message

	validates :name, presence: true
	validates :email, presence: true
end

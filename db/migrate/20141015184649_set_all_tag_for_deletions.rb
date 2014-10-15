class SetAllTagForDeletions < ActiveRecord::Migration
  def up
		change_column :posts, :tag_for_deletion, :boolean, default: false

		posts = Post.all
		posts.each do |post|
			post.tag_for_deletion = false
			if post.save
				puts "#{post.id} successfully set"
			else
				puts "#{post.id} unable to set tag_for_deletion attribute"
			end
		end
  end

  def down
		change_column :posts, :tag_for_deletion, :boolean, default: nil
  end
end

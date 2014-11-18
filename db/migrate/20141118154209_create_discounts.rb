class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :discount_code
      t.float :amount
      t.string :genre
      t.string :campaign_name
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end

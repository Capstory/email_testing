class ChangeVendorIdInVendorEmployees < ActiveRecord::Migration
  def up
    add_column :vendor_employees, :vendor_page_id, :integer
    
    ves = VendorEmployee.all
    ves.each do |employee|
      unless employee.vendor_id.nil?
        employee.vendor_page_id = employee.vendor_id
        if employee.save
          puts "#{employee.name} - ID transferred to vendor_page_id"
        else
          puts "#{employee.name} - Unable to tranfer ID"
        end
      end
    end
    
    remove_column :vendor_employees, :vendor_id
  end

  def down
    add_colum :vendor_employees, :vendor_id, :integer
    
    ves = VendorEmployee.all
    ves.each do |employee|
      unless employee.vendor_page_id.nil?
        employee.vendor_id = employee.vendor_page_id
        if employee.save
          puts "#{employee.name} - ID transferred to vendor_id"
        else
          puts "#{employee.name} - Unable to tranfer ID"
        end
      end
    end
    
    remove_column :vendor_employees, :vendor_page_id
  end
end

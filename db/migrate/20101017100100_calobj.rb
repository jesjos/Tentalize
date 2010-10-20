class Calobj < ActiveRecord::Migration
  def self.up
    remove_column :calendars, :calObject
    remove_column :calendars, :calObj
  end

  def self.down
    add_column :calendars, :calObj, :binary
  end
end

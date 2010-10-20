class Calbinary < ActiveRecord::Migration
  def self.up
    add_column :calendars, :cal_dump, :binary
  end

  def self.down
    remove_column :calendars, :cal_dump
  end
end

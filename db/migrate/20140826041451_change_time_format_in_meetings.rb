class ChangeTimeFormatInMeetings < ActiveRecord::Migration
  def change
    change_column :meetings, :time, :datetime
  end
end

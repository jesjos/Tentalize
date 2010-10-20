class Calendar < ActiveRecord::Base
  def self.get_all
    c = Marshal.load(Calendar.last.cal_dump)
    events = {}
    c.events.each do |c|
      if events.has_key? c.location
        events[c.location].push({:state => :occupied, :start => c.occurences.first, :duration => c.duration})
      else
        events.store(c.location, Array[{:state => :occupied, :start => c.occurences.first, :duration => c.duration}])
      end
    end
    return events
  end
  
  def self.get_rooms_today
    rooms = self.get_all
    rooms.each_value do |times| 
      times.reject!{|time| not time[:start].today?} 
    end
    return rooms
  end
  
  def self.get_available
    result = {}
    rooms = self.get_rooms_today
    rooms.each do |value,times|
      if times.empty?
        result[:full_day] = value
      end
    end
  end
  
  def self.get_day(hash)
    rooms = self.get_all
    theDay = hash[:day]
    if theDay != nil
      d = theDay.to_time
      rooms.each_value do |times|
        times.reject!{|time| not time[:start].midnight == d.midnight}
      end
    end
    unless rooms.empty?
      rooms.each_value do |times|
        first_event = times.first[:start]
        start_of_day = times.first[:start].change(:hour => 8)
        if first_event > start_of_day
          times.insert(0, :state => :available, :start => start_of_day, :duration => first_event - start_of_day)
        end
        i = 0
        until i == (times.length() -1) do
          unless times.empty?
            this_event_end = times[i][:start] + times[i][:duration]
            next_e_start = times[i+1][:start]
            if this_event_end < next_e_start
              times.insert(i+1, :state => :available, :start => this_event_end, :duration => next_e_start - this_event_end)
            end
          end
          i += 1
        end
      end
    else
      rooms.store(:state => :whole_day, :start => theDay.change(:hour => 8), :duration => 57600)
    end
    return rooms
  end
end

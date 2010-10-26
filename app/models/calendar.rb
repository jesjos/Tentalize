class Calendar < ActiveRecord::Base
  def self.get_all
    c = Marshal.load(Calendar.last.cal_dump)
    events = {}
    c.events.each do |c|
      if events.has_key? c.location
        events[c.location].push(Event.new(:state => :occupied, :start => c.occurences.first, :duration => c.duration))
      else
        events.store(c.location, Array[Event.new(:state => :occupied, :start => c.occurences.first, :duration => c.duration)])
      end
    end
    return events
  end
  
  def self.get_rooms_today
    rooms = self.get_all
    rooms.each_value do |events| 
      events.reject!{|event| not event.today?} 
    end
    return rooms
  end
  
  # Ofullständig!
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
      rooms.each_value do |eventarray|
        if eventarray.empty?
          eventarray.push(Event.empty_day(d))
        else
          eventarray.reject!{|event| not event.same_day?(d)}
        end
      end
    end
    unless rooms.empty?
      rooms.each_value do |events|
        # Går igenom tiderna och lägger till tomma block i början av dagen om första händelsen börjar senare än kl 8
        first_event = events.first.start
        start_of_day = first_event.change(:hour => 8)
        if first_event > start_of_day
          events.insert(0, Event.new(:state => :available, :start => start_of_day, :duration => first_event - start_of_day))
        end
        i = 0
        until i == (events.length() -1) do
          unless events.empty?
            this_event_end = events[i].start + events[i].duration
            next_e_start = events[i+1].start
            if this_event_end < next_e_start
              events.insert(i+1, Event.new(:state => :available, :start => this_event_end, :duration => next_e_start - this_event_end))
            end
          end
          i += 1
        end
      end
    else
      rooms.store(Event.new(:state => :whole_day, :start => theDay.change(:hour => 8), :duration => 57600))
    end
    return rooms
  end
  
  # def self.rank
  #   ranked = {}
  #   rooms = self.get_day(:day => Time.now)
  #   unless rooms.empty?
  #     rooms.each do |room, times|
  #       if times.[:state] = :whole_day
  #         ranked.store()
end
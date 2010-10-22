class Event
  def initialize (args)
    @state = args[:state]
    @start = args[:start]
    @duration = args[:duration]
  end
  
  def self.whole_day(the_day)
    d = the_day.change(:hour => 8)
    e = Event.new(:state => :whole_day, :duration => 57600, :start => d)
    return e
  end
  
  def end
    return self.start + self.duration
  end
  
  # Kollar om argumenttiden ingår i det aktuella eventet 
  def contains(time)
    if time.is_a? Time
      t = time
    else
      t = time.start
    end
    return t > self.start && t < self.end
  end
  
  attr_accessor :state, :start, :duration
  
end
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
  
  def contains(time)
    time = time.to_time
    return time > self.start && time < self.end
  end
  
  attr_accessor :state, :start, :duration
  
end
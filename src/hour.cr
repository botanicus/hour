require "./hour/*"

class Hour
  # Abstract time unit class.
  #
  # Subclasses are decorating the `Hour` class with functionality
  # specific for their particular type (hours, minutes and seconds).
  private abstract class Unit
    # Value is expected to be defined.
    abstract def value

    def initialize(@hour : Hour)
    end
  end

  private class HourUnit < Unit
    def value : Int32
      @hour.h
    end

    def round : Int32
      self.value + ((0..29).includes?(@hour.m) ? 0 : 1)
    end
  end

  private class MinuteUnit < Unit
    def value : Int32
      @hour.m
    end

    def round : Int32
      self.value + ((0..29).includes?(@hour.s) ? 0 : 1)
    end

    def total : Int32
      @hour.h * 60 + self.value
    end

    def round_total : Int32
      self.total + ((0..29).includes?(@hour.s) ? 0 : 1)
    end
  end

  private class SecondUnit < Unit
    def value : Int32
      @hour.s
    end

    def total : Int32
      @hour.h * 60 * 60 + @hour.m * 60 + self.value
    end
  end

  # TODO: Test me and document me.
  def self.now : self
    self.from_time(Time.now)
  end

  # TODO: document and write tests.
  def self.from_time(time)
    self.new(h: time.hours, m: time.minutes, s: time.seconds)
  end

  # Build an hour instance from an hour string.
  #
  #     Hour.parse("1:00:00")
  #     Hour.parse("1:00", "%h:%m?") # Will work with "1:00" or just "1".
  #
  # TODO: Implement me, test me and document me.
  def self.parse(serialised_hour : String) # : self
    argument_array = serialised_hour.split(':').map &.to_i

    case argument_array.size
    when 3
      p arguments = Tuple(Int32).from(argument_array)
      # self.new(*Tuple(String).from(parts))
    when (0..2)
      # TODO: if formatting_string ...
      raise ArgumentError.new("If format is not H:M:S, formatting string must be provided.")
    when (4..10) # TODO: Infinity.
      raise ArgumentError, "Too many arguments."
    end
  end

  # Build an hour instance from *either* **minutes** *or* **seconds**.
  # Unlike `.new`, either of these values can be over 60.
  #
  #     Hour.from(minutes: 85)  # => Hour.new(h: 1, m: 25)
  #     Hour.from(seconds: 120) # => Hour.new(m: 2)
  def self.from(minutes = 0, seconds = 0) : self
    if minutes != 0 && seconds != 0
      raise ArgumentError.new("Use either minutes OR seconds, not both.")
    end

    if minutes > 0
      self.new(h: minutes / 60, m: minutes % 60)
    else
      self.from(minutes: seconds / 60) + self.new(s: seconds % 60)
    end
  end

  protected getter h, m, s

  # Build an hour instance from *h*, *m* and *s*.
  # Raises an argument error if *m* or *s* is a value over 60.
  #
  # For instantiating this class from a *minutes* or *seconds* value over 60, use `.from`.
  def initialize(@h = 0, @m = 0, @s = 0)
    if @m > 60
      raise ArgumentError.new("Minutes must be a number between 0 and 60.")
    end

    if @s > 60
      raise ArgumentError.new("Seconds must be a number between 0 and 60.")
    end
  end

  # Returns a new Hour instance returning the total time of the two hour instances.
  #
  #     Hour.new(m: 25, s: 10) + Hour.new(h: 1) # => Hour.new(1, 25, 10)
  def +(other : Hour) : Hour
    hours = @h + other.h + (@m + other.m + ((@s + other.s) / 60)) / 60
    minutes = (@m + other.m + ((@s + other.s) / 60)) % 60
    seconds = (@s + other.s) % 60
    self.class.new(hours, minutes, seconds)
  end

  # Returns a decorator providing convenience methods for working with hours.
  #
  #     Hour.new(1, 25).hours.round # => 1
  #     Hour.new(1, 45).hours.round # => 2
  def hours
    HourUnit.new(self)
  end

  # Returns a decorator providing convenience methods for working with minutes.
  #
  #     Hour.new(1, 25, 52).minutes.value       # => 25
  #     Hour.new(1, 25, 52).minutes.round       # => 26
  #     Hour.new(1, 25, 52).minutes.total       # => 85
  #     Hour.new(1, 25, 52).minutes.round_total # => 86
  def minutes
    MinuteUnit.new(self)
  end

  # Returns a decorator providing convenience methods for working with seconds.
  #
  #     Hour.new(m: 1, s: 10).seconds.value # => 10
  #     Hour.new(1, 45, 10  ).seconds.total # => (1 * 60 * 60) + (45 * 60) + 10
  def seconds
    SecondUnit.new(self)
  end

  # TODO: Add formatting string support.
  # TODO: Pad 0s. I. e. "#{self.hours}:#{format('%02d', self.minutes_over_the_hour)}"
  def to_s(format : String?) : String
    "#{@h}:#{@m}:#{@s}"
  end

  # alias_method :inspect, :to_s

  def to_time(today = Time.now)
    Time.new(today.year, today.month, today.day, self.hours, self.minutes_over_the_hour)
  end
end

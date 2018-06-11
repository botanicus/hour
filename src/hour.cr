require "./hour/*"

class Hour
  class Unit
    getter  total, value
    def initialize(@hour : Hour)
    end
  end

  # 1:45:00.hours.value => 1
  # 1:45:00.hours.round => 2
  class HourUnit < Unit
    def value : Int32
      @hour.h
    end

    def round : Int32
      self.value + ((0..30).includes?(@hour.m) ? 0 : 1)
    end
  end

  # 1:45:52.minutes.value => 45
  # 1:45:52.minutes.round => 46
  #
  # 1:45:52.minutes.total => 105
  # 1:45:52.minutes.round_total => 106
  class MinuteUnit < Unit
    def value : Int32
      @hour.m
    end

    def round : Int32
      self.value + ((0..30).includes?(@hour.s) ? 0 : 1)
    end

    def total : Int32
      @hour.h * 60 + self.value
    end

    def round_total : Int32
      self.total + ((0..30).includes?(@hour.s) ? 0 : 1)
    end
  end

  class SecondUnit < Unit
    def value : Int32
      @hour.s
    end

    def total : Int32
      @hour.h * 60 * 60 + @hour.m * 60 + self.value
    end
  end

  def self.now : self
    self.new(h: Time.now.hours, m: Time.now.minutes, s: Time.now.seconds)
  end

  # Hour.parse("1:00:00")
  # Hour.parse("1:00", "%h:%m?") # Will work with "1:00" or just "1".
  def self.parse(serialised_hour : String) #: self
    argument_array = serialised_hour.split(':').map &.to_i

    if argument_array.size < 3
      raise ArgumentError.new("If format is not H:M:S, formatting string must be provided.")
    end

    p arguments = Tuple(Int32).from(argument_array)
    # self.new(*Tuple(String).from(parts))
  end

  # Hour.from(minutes: 85)
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

  getter h, m, s

  # Hour.new(1)
  # Hour.new(m: 25)
  def initialize(@h = 0, @m = 0, @s = 0)
    if @m > 60
      raise ArgumentError.new("Minutes must be a number between 0 and 60.")
    end

    if @s > 60
      raise ArgumentError.new("Seconds must be a number between 0 and 60.")
    end
  end

  def +(other : Hour) : Hour
    hours = @h + other.h + (@m + other.m + ((@s + other.s) / 60)) / 60
    minutes = (@m + other.m + ((@s + other.s) / 60)) % 60
    seconds = (@s + other.s) % 60
    self.class.new(hours, minutes, seconds)
  end

  def hours
    HourUnit.new(self)
  end

  def minutes
    MinuteUnit.new(self)
  end

  def seconds
    SecondUnit.new(self)
  end

  def to_s(format : String?) : String
    # TODO
    "#{@h}:#{@m}:#{@s}"
  end
end

require "./spec_helper"

describe Hour do
  describe ".parse" do
    it "..." do
      # p Hour.parse("1:02:30")
      p Hour.new(1)
      p Hour.new(m: 1)
      puts

      p Hour.new(1, 45).hours.value # 1
      p Hour.new(1, 45).hours.round # 2
      puts

      p Hour.new(1, 25, 52).minutes.value       # 25
      p Hour.new(1, 25, 52).minutes.round       # 26
      p Hour.new(1, 25, 52).minutes.total       # 85
      p Hour.new(1, 25, 52).minutes.round_total # 86
      puts

      p Hour.new(m: 1, s: 25).seconds.value # 25
      p Hour.new(m: 1, s: 25).seconds.total # 85
      puts

      p Hour.from(minutes: 85)
      p Hour.from(seconds: 85 * 60)
      puts

      p Hour.new(m: 25) + Hour.new(h: 1)
    end
  end
end

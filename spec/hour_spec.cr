require "./spec_helper"

describe Hour do
  describe ".new" do
    it "takes up to three arguments" do
      Hour.new(1).h.should eq(1)
      Hour.new(1).m.should eq(0)
      Hour.new(1).s.should eq(0)

      Hour.new(1, 2).h.should eq(1)
      Hour.new(1, 2).m.should eq(2)
      Hour.new(1, 2).s.should eq(0)

      Hour.new(1, 2, 3).h.should eq(1)
      Hour.new(1, 2, 3).m.should eq(2)
      Hour.new(1, 2, 3).s.should eq(3)
    end

    it "takes keyword arguments h, m, s" do
      Hour.new(h: 1).h.should eq(1)

      Hour.new(h: 1, m: 2).h.should eq(1)
      Hour.new(h: 1, m: 2).m.should eq(2)
      Hour.new(h: 1, m: 2).s.should eq(0)

      Hour.new(s: 10).h.should eq(0)
      Hour.new(s: 10).m.should eq(0)
      Hour.new(s: 10).s.should eq(10)

      Hour.new(h: 1, s: 10).h.should eq(1)
      Hour.new(h: 1, s: 10).m.should eq(0)
      Hour.new(h: 1, s: 10).s.should eq(10)
    end
  end

  describe ".parse" do
    pending "implement me" do
      # TODO
      # p Hour.parse("1:02:30")
    end
  end

  describe "#to_s" do
    pending "implement me" do
      # TODO
    end
  end

  describe "#+" do
    it "returns a new Hour instance returning the total time of the two hour instances" do
      hour = Hour.new(m: 25, s: 10) + Hour.new(h: 1)
      hour.hours.value.should eq(1)
      hour.minutes.value.should eq(25)
      hour.seconds.value.should eq(10)
    end
  end

  describe ".from" do
    context "minutes" do
      it "returns a new Hour instance" do
        hour = Hour.from(minutes: 85)
        hour.hours.value.should eq(1)
        hour.minutes.value.should eq(25)
        hour.seconds.value.should eq(0)
      end
    end

    context "seconds" do
      it "returns a new Hour instance" do
        hour = Hour.from(seconds: 2 * 60 * 60 + 25 * 60 + 5)
        hour.hours.value.should eq(2)
        hour.minutes.value.should eq(25)
        hour.seconds.value.should eq(5)
      end
    end
  end

  describe "#hours" do
    describe "#value" do
      it "returns the exact hour value" do
        Hour.new(1, 10).hours.value.should eq(1)
        Hour.new(1, 59).hours.value.should eq(1)
      end
    end

    describe "#round" do
      it "returns the rounded hour" do
        Hour.new(1, 10).hours.round.should eq(1)
        Hour.new(1, 29, 59).hours.round.should eq(1)
        Hour.new(1, 30).hours.round.should eq(2)
        Hour.new(1, 59).hours.round.should eq(2)
      end
    end
  end

  describe "#minutes" do
    describe "#value" do
      it "returns the exact minute value" do
        Hour.new(1, 25, 52).minutes.value.should eq(25)
      end
    end

    describe "#round" do
      it "returns the rounded minutes" do
        Hour.new(1, 25, 52).minutes.round.should eq(26)
      end
    end

    describe "#total" do
      it "returns the total number of minutes" do
        Hour.new(1, 25, 52).minutes.total.should eq(85)
      end
    end

    describe "#round_total" do
      it "returns the rounded total number of minutes" do
        Hour.new(1, 25, 52).minutes.round_total.should eq(86)
      end
    end
  end

  describe "#seconds" do
    describe "#value" do
      it "returns the exact second value" do
        Hour.new(m: 1, s: 25).seconds.value.should eq(25)
      end
    end

    describe "#total" do
      it "returns the exact total number of seconds" do
        Hour.new(m: 1, s: 25).seconds.total.should eq(85)
        Hour.new(1, 10, 25).seconds.total.should eq(1 * 60 * 60 + 10 * 60 + 25)
      end
    end
  end
end

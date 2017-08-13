require File.dirname(__FILE__) + '/../spec_helper'

describe CalendarDateSelect do
  it "detects presence of time in a string" do
    expect(CalendarDateSelect.has_time?("January 7, 2007")).to eq false
    expect(CalendarDateSelect.has_time?("January 7, 2007 5:50pm")).to eq true
    expect(CalendarDateSelect.has_time?("January 7, 2007 5:50 pm")).to eq true
    expect(CalendarDateSelect.has_time?("January 7, 2007 16:30 pm")).to eq true

    expect(CalendarDateSelect.has_time?(Date.parse("January 7, 2007 3:00 pm"))).to eq false
    expect(CalendarDateSelect.has_time?(Time.parse("January 7, 2007 3:00 pm"))).to eq true
    expect(CalendarDateSelect.has_time?(DateTime.parse("January 7, 2007 3:00 pm"))).to eq true
  end
end

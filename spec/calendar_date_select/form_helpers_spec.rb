require File.dirname(__FILE__) + '/../spec_helper'

describe CalendarDateSelect::FormHelpers do
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper

  include CalendarDateSelect::FormHelpers

  before(:each) do
    @controller = ActionController::Base.new
    @request = OpenStruct.new
    @controller.request = @request

    @model = OpenStruct.new
  end

  describe "mixed mode" do
    it "should not output a time when the value is a Date" do
      @model.start_datetime = Date.parse("January 2, 2007")
      output = calendar_date_select(:model, :start_datetime, :time => "mixed")
      expect(output).to_not  match(/12:00 AM/)
    end

    it "should output a time when the value is a Time" do
      @model.start_datetime = Time.parse("January 2, 2007 12:00 AM")
      output = calendar_date_select(:model, :start_datetime, :time => "mixed")
      expect(output).to match(/12:00 AM/)
    end
  end

  it "should render a time when time is passed as 'true'" do
    @model.start_datetime = Date.parse("January 2, 2007")
    output = calendar_date_select(:model, :start_datetime, :time => "true")
    expect(output).to match(/12:00 AM/)
  end

  it "should time_false__model_returns_time__should_render_without_time" do
    @model.start_datetime = Time.parse("January 2, 2007 12:00 AM")
    output = calendar_date_select(:model, :start_datetime)
    expect(output).to_not  match(/12:00 AM/)
  end

  it "should _nil_model__shouldnt_populate_value" do
    @model = nil
    output = calendar_date_select(:model, :start_datetime)

    expect(output).to_not  match(/value/)
  end

  describe "default time mode" do
    it "should wrap default date in javascript function when passed as string" do
      @model.start_datetime = nil
      output = calendar_date_select(:model, :start_datetime, :default_time => "new Date()")
      expect(output).to match(/value=""/)
      expect(output).to include("default_time:function() { return new Date() }")
    end

    it "should wrap formatted date with default time with Date() when passed a date object" do
      @model.start_datetime = nil
      output = calendar_date_select(:model, :start_datetime, :default_time => Date.parse("January 2, 2007"))
      expect(output).to match(/value=""/)
      expect(output).to include("default_time:new Date(&#39;January 02, 2007 12:00 AM&#39;)")
    end

    it "should wrap formatted date and time with Date() when passed a time object" do
      @model.start_datetime = nil
      output = calendar_date_select(:model, :start_datetime, :default_time => Time.parse("January 2, 2007 5:45 PM"))
      expect(output).to match(/value=""/)
      expect(output).to include("default_time:new Date(&#39;January 02, 2007 05:45 PM&#39;)")
    end
  end

  it "should _vdc__should_auto_format_function" do
    @model.start_datetime = Time.parse("January 2, 2007 12:00 AM")
    output = calendar_date_select(:model,
      :start_datetime,
      :valid_date_check => "date < new Date()"
    )
    expect(output).to include("valid_date_check:function(date) { return(date &lt; new Date()) }")

    output = calendar_date_select(:model,
      :start_datetime,
      :valid_date_check => "return(date < new Date())"
    )
    expect(output).to include("valid_date_check:function(date) { return(date &lt; new Date()) }")
    output = calendar_date_select(:model,
      :start_datetime,
      :valid_date_check => "function(p) { return(date < new Date()) }"
    )
    expect(output).to include("valid_date_check:function(p) { return(date &lt; new Date()) }")
  end

  it "should raise an error if the valid_date_check function is missing a return statement" do
    message = ":valid_date_check function is missing a 'return' statement.  Try something like: :valid_date_check => 'if (date > new(Date)) return true; else return false;'"
    expect {
      output = calendar_date_select(:model,
        :start_datetime,
        :valid_date_check => "date = 5; date < new Date());"
      )
    }.to raise_error(ArgumentError, message)

    expect {
      output = calendar_date_select(:model,
        :start_datetime,
        :valid_date_check => "function(p) { date = 5; date < new Date()); }"
      )
    }.to raise_error(ArgumentError, message)
  end

  it "should render the year_range argument correctly" do
    output = calendar_date_select(:model, :start_datetime)
    expect(output).to include("year_range:10")
    output = calendar_date_select(:model, :start_datetime, :year_range => 2000..2010)
    expect(output).to include("year_range:[2000, 2010]")
    output = calendar_date_select(:model, :start_datetime, :year_range => (15.years.ago..5.years.ago))
    expect(output).to include("year_range:[#{15.years.ago.year}, #{5.years.ago.year}]")
  end

  it "should disregard the :object parameter when nil" do
    @model.start_datetime = Time.parse("January 2, 2007 12:00 AM")
    output = calendar_date_select(:model, :start_datetime, :time => true, :object => nil)
    expect(output).to include(CalendarDateSelect.format_date(@model.start_datetime))
  end

  it "should regard :object parameter" do
    @model.start_datetime = Time.parse("January 2, 2007 12:00 AM")
    output = calendar_date_select(:lame_o, :start_datetime, :time => true, :object => @model)
    expect(output).to include(CalendarDateSelect.format_date(@model.start_datetime))
  end

  it "should respect parameters provided in default_options" do
    new_options = CalendarDateSelect.default_options.merge(:popup => "force")
    allow( CalendarDateSelect ).to receive( :default_options ).and_return( new_options )
    expect(calendar_date_select_tag(:name, "")).to include("popup:&#39;force&#39;")
  end

  it "should respect the :image option" do
    output = calendar_date_select_tag(:name, "Some String", :image => "boogy.png")
    expect(output).to include("boogy.png")
  end

  it "should not pass the :image option as a javascript option" do
    output = calendar_date_select_tag(:name, "Some String", :image => "boogy.png")
    expect(output).to_not include("image:")
  end

  it "should use the CSS class calendar_date_select_tag for popup selector icon" do
    output = calendar_date_select_tag(:name, "Some String", :image => "boogy.png")
    expect(output).to include("calendar_date_select_popup_icon")
  end

  describe "calendar_date_select_tag" do
    before(:each) do
      @time = Time.parse("January 2, 2007 12:01:23 AM")
    end

    it "should use the string verbatim when provided" do
      output = calendar_date_select_tag(:name, "Some String")

      expect(output).to include("Some String")
    end

    it "should not render the time when time is false (or nil)" do
      output = calendar_date_select_tag(:name, @time, :time => false)

      expect(output).to_not  match(/12:01 AM/)
      expect(output).to include(CalendarDateSelect.format_date(@time.to_date))
    end

    it "should render the time when :time => true" do
      output = calendar_date_select_tag(:name, @time, :time => true)

      expect(output).to include(CalendarDateSelect.format_date(@time))
    end

    it "should render the time when :time => 'mixed'" do
      output = calendar_date_select_tag(:name, @time, :time => 'mixed')
      expect(output).to include(CalendarDateSelect.format_date(@time))
    end

    it "not include the image option in the result input tag" do
      output = calendar_date_select_tag(:name, @time, :time => 'mixed')
      expect(output).to_not include("image=")
    end
  end
end

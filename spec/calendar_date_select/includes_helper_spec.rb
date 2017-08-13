require File.dirname(__FILE__) + '/../spec_helper'

describe CalendarDateSelect::IncludesHelper do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include CalendarDateSelect::IncludesHelper

  describe "calendar_date_select_includes" do
    it "should include the specified locale" do
      expect(calendar_date_select_includes(:locale => "fr")).to include("calendar_date_select/locale/fr.js")
    end

    it "should include the specified style" do
      expect(calendar_date_select_includes(:style => "blue")).to include("calendar_date_select/blue.css")
    end

    it "should complain if you provide an illegitimate argument" do
      expect { calendar_date_select_includes(:language => "fr") }.to raise_error(ArgumentError)
    end
  end

  describe "calendar_date_select_javascripts" do
    it "should return an array of javascripts" do
      expect(calendar_date_select_javascripts).to eq ["calendar_date_select/calendar_date_select"]
    end

    it "should return the :javascript_include of the specified format, if the specified format expects it" do
      allow( CalendarDateSelect ).to receive( :format ).and_return( CalendarDateSelect::FORMATS[ :hyphen_ampm ] )
      expect(calendar_date_select_javascripts).to eq ["calendar_date_select/calendar_date_select", "calendar_date_select/format_hyphen_ampm"]
    end

    it "should blow up if an illegitimate argument is passed" do
      expect { calendar_date_select_javascripts(:language => "fr") }.to raise_error(ArgumentError)
    end
  end

  describe "calendar_date_select_stylesheets" do
    it "should return an array of stylesheet" do
      expect(calendar_date_select_javascripts).to eq ["calendar_date_select/calendar_date_select"]
    end

    it "should blow up if an illegitimate argument is passed" do
      expect { calendar_date_select_stylesheets(:css_version => "blue") }.to raise_error(ArgumentError)
    end
  end
end

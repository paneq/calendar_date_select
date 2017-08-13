require 'rubygems'

require 'rspec'

gem 'railties', '~> 4.2.0'
gem 'activesupport', '~> 4.2.0'
gem 'actionpack', '~> 4.2.0'

require 'active_support'
require 'action_pack'
require 'action_controller'
require 'action_view'

require 'ostruct'

$: << (File.dirname(__FILE__) + "/../lib")
require "calendar_date_select"

class String
  def to_regexp
    is_a?(Regexp) ? self : Regexp.new(Regexp.escape(self.to_s))
  end
end

module CalendarDateSelectFormHelpers
  class CalendarDateSelectTag
    def options_for_javascript(options)
      if options.empty?
        '{}'
      else
        "{#{options.keys.map { |k| "#{k}:#{options[k]}" }.sort.join(', ')}}"
      end
    end
  end
end

RSpec.configure do | config |

  # http://stackoverflow.com/questions/1819614/how-do-i-globally-configure-rspec-to-keep-the-color-and-format-specdoc-o
  #
  # Use color in STDOUT,
  # use color not only in STDOUT but also in pagers and files.

  config.color = true
  config.tty   = true

end

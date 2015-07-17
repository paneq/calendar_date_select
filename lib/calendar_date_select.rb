require "calendar_date_select/calendar_date_select.rb"
require "calendar_date_select/form_helpers.rb"
require "calendar_date_select/includes_helper.rb"

require 'rails'
require 'active_support'

module CalendarDateSelect

  Files = [
    '/lib/assets',
    '/lib/assets/javascripts/calendar_date_select',
    '/lib/assets/stylesheets/calendar_date_select', 
    '/lib/assets/images/calendar_date_select',
    '/lib/assets/javascripts/calendar_date_select/locale'
  ]

  module Rails
    class Engine < ::Rails::Engine
    end
  end

  class Railtie < ::Rails::Railtie

    initializer 'calendardateselect.initialize', :after => :action_view do
      ActionView::Helpers::FormHelper.send(:include, CalendarDateSelect::FormHelpers)
      ActionView::Base.send(:include, CalendarDateSelect::FormHelpers)
      ActionView::Base.send(:include, CalendarDateSelect::IncludesHelper)

      ActionView::Helpers::InstanceTag.class_eval do
        class << self; alias new_with_backwards_compatibility new; end #TODO: singleton_class.class_eval
      end
    end

    rake_tasks do
      namespace :calendar do
        desc "Install assets required by calendar_date_select gem"
        task :install do

          Files.each do |f|
            source = File.join(File.dirname(__FILE__), "..", f)
            dest = File.join(Rails.root, f)
            FileUtils.mkdir_p(dest, :verbose => true)
            FileUtils.cp(Dir.glob(source+'/*.*'), dest, :verbose => true)
          end

        end # task
      end #namespace
    end # rake_tasks
  end # Railtie
end # module


require 'chillout/creation_listener'

module Chillout
  class Railtie < Rails::Railtie
    config.chillout = ActiveSupport::OrderedOptions.new
    initializer "chillout.creations_listener_initialization" do |rails_app|
      chillout_config = rails_app.config.chillout
      return if chillout_config.empty?
      RailsInitializer.new(rails_app, chillout_config, Rails.logger).start
    end

    rake_tasks do
      load "chillout/tasks.rb"
    end
  end

  class RailsInitializer
    
    def initialize(rails_app, chillout_config, rails_logger)
      @rails_app = rails_app
      @chillout_config = chillout_config
      @rails_logger = rails_logger
    end

    def start
      client = Client.new(@chillout_config[:secret], options)
      ActiveRecord::Base.extend(CreationListener)
      @rails_app.middleware.use Middleware::CreationsMonitor, client
      client.start_worker
    end

    def options
      Hash[options_list].merge(:logger => @rails_logger)
    end

    def options_list
      existing_option_keys.map{|key| [key, @chillout_config[key]]}
    end

    def existing_option_keys
      [:port, :hostname, :ssl].select{|key| @chillout_config.has_key?(key)}
    end

  end
end

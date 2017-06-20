require "chillout/version"
require "chillout/config"
require "chillout/middleware/creations_monitor"
require "chillout/server_side/dispatcher"
require "chillout/server_side/server_side"
require "chillout/server_side/http_client"
require "chillout/custom_metric"
require "chillout/client"

module Chillout
  Metric = CustomMetric.new

  def self.creations
    Thread.current[:creations]
  end

  def self.creations=(val)
    Thread.current[:creations] = val
  end
end

require 'chillout/railtie' if defined?(Rails)


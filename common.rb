require "logger"
require "pg"
require "que"
require "sequel"

class DummyJob < Que::Job
  def run
    sleep 0.01
  end
end

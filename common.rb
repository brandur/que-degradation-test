require "logger"
require "pg"
require "que"
require "sequel"

BATCH_SIZE     = ENV['BATCH_SIZE']   || 100
DATABASE_URL   = ENV['DATABASE_URL'] || abort("no DATABASE_URL")
METRICS_SOURCE = ENV['METRICS_SOURCE']
WORKER_COUNT   = ENV['WORKER_COUNT'] || 8

class DummyJob < Que::Job
  def run
    sleep 0.01
  end
end

# IMPORTANT! `puts` is not thread safe! Use `print`.
class Metrics
  PREFIX = "que-degradation-test"

  def self.count(name)
    log "count##{PREFIX}.#{name}"
  end

  def self.measure(name, value = nil)
    ret = nil
    v = if block_given?
      t = Time.now
      ret = yield
      Time.now - t
    else
      raise ArgumentError, "need value without block" unless value
      value
    end
    log "measure##{PREFIX}.#{name}=#{v}s"
    ret
  end

  def self.sample(name, value, units)
    log "sample##{PREFIX}.#{name}=#{value}#{units}"
  end

  private

  def self.log(message)
    message += " source=#{METRICS_SOURCE}" if METRICS_SOURCE
    message += "\n"
    print message
  end
end

module Que
  class << self
    alias_method :que_execute, :execute

    def execute(*args)
      if args.first && args.first == :lock_job
        Metrics.measure "lock-time" do
          que_execute(*args)
        end
      else
        que_execute(*args)
      end
    end
  end
end

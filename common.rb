require "logger"
require "pg"
require "que"
require "sequel"

BATCH_SIZE   = ENV['BATCH_SIZE']   || 100
DATABASE_URL = ENV['DATABASE_URL'] || abort("no DATABASE_URL")
WORKER_COUNT = ENV['WORKER_COUNT'] || 8

class DummyJob < Que::Job
  def run
    sleep 0.01
  end
end

class Metrics
  PREFIX = "que-degradation-test"

  def self.count(name)
    puts "count##{PREFIX}.#{name}"
  end

  def self.measure(name, value = nil)
    t = Time.now
    v = if block_given?
      yield
    else
      raise ArgumentError, "need value without block" unless value
      value
    end
    puts "measure##{PREFIX}.#{name}=#{v}s"
  end

  def self.sample(name, value, units)
    puts "sample##{PREFIX}.#{name}=#{value}#{units}"
  end
end

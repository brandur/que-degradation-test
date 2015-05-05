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

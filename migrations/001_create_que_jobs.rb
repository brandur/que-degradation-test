Sequel.migration do
  up do
    require "que"
    Que.connection = DB
    Que.migrate!
  end
end

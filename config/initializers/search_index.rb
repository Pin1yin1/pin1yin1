if ENV['RAILS_INDEX_DIR']
  ActsAsIndexed.configure do |config|
    config.index_file = Pathname.new(ENV['RAILS_INDEX_DIR'])
  end
end

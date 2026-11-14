RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end

  config.before do
    DatabaseCleaner[:active_record].strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner[:active_record].strategy = :truncation
  end

  config.before do
    DatabaseCleaner[:active_record].start
  end

  config.after do
    DatabaseCleaner[:active_record].clean
  end

end

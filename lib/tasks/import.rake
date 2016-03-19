namespace :db do
  
  task :import_bopomofo => :environment do
    load 'script/import/import_bopomofo.rb'
  end
  
  task :import_cedict => [:import_bopomofo, :environment] do
    load 'script/import/import_cedict.rb'
  end
  
  task :import_zi => [:import_bopomofo, :import_cedict, :environment] do
    load 'script/import/import_zi.rb'
  end
  
  task :record_definition_characters => [:import_cedict, :import_zi, :environment] do
    load 'script/import/record_definition_characters.rb'
  end
  
  task :import => [:import_bopomofo, :import_cedict, :import_zi, :record_definition_characters] do
  end
  
end

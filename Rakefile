namespace :import do
  
  task :file, :file, :db do |t, args|
    raise "Please specify a file to import" unless args[:file]
    raise "Please specify a target database in the expecting string format" unless args[:db]
    
    parser = CStrikeParser.new(File.expand_path(File.dirname(__FILE__) + args[:file], args[:db])
    parser.parse!
  end
  
end
require 'lib/cstrike_parser'

describe CStrikeParser do
  
  before(:all) do
      DataMapper::Logger.new($stdout, :debug)
      DataMapper::Model.raise_on_save_failure = true
      DataMapper::Property::String.length(255)
      DataMapper.setup(:default, "sqlite::memory:")
      DataMapper.finalize

      DataMapper.auto_migrate!
  end
  
  it "should find a session" do
    csp = CStrikeParser.new(File.expand_path(File.dirname(__FILE__) + '/some_messages.log'))
    sessions = csp.parse!
    
    sessions.size.should == 1
  end
  
  it "should find some rounds in a session" do
    csp = CStrikeParser.new(File.expand_path(File.dirname(__FILE__) + '/some_messages.log'))
    sessions = csp.parse!
    
    sessions[0].rounds.size.should == 1
  end
  
  it "should identify players" do
    csp = CStrikeParser.new(File.expand_path(File.dirname(__FILE__) + '/some_messages.log'))
    sessions = csp.parse!
    
    Player.all.size.should == 4
    sessions[0].players.all.size.should == 4
    sessions[0].rounds[0].players.all.size.should == 4
  end
  
  it "should identify messages" do
    csp = CStrikeParser.new(File.expand_path(File.dirname(__FILE__) + '/some_messages.log'))
    sessions = csp.parse!
    
    sessions[0].rounds[0].messages.size.should == 5
    sessions[0].rounds[0].messages.all(:alive => false).size.should == 2
    sessions[0].rounds[0].messages.all(:private => true).size.should == 3
  end
  
  it "should find some attack lines" do
    csp = CStrikeParser.new(File.expand_path(File.dirname(__FILE__) + '/some_attacks.log'))
    sessions = csp.parse!
    
    sessions[0].rounds[0].attacks.size.should == 15
    sessions[0].rounds[0].attacks.team.size.should == 1
    sessions[0].rounds[0].attacks.last.kill.should_not be_nil
  end
  
  it "should identify headshots" do
    csp = CStrikeParser.new(File.expand_path(File.dirname(__FILE__) + '/some_attacks.log'))
    sessions = csp.parse!
    
    sessions[0].rounds[0].attacks.headshots.size.should == 2
  end
  
  it "should find some kills" do
    csp = CStrikeParser.new(File.expand_path(File.dirname(__FILE__) + '/some_kills.log'))
    sessions = csp.parse!
    
    sessions[0].rounds[0].kills.size.should == 4
    sessions[0].rounds[0].kills.all(:weapon => :glock18).size.should == 2
    sessions[0].rounds[0].kills.team.size.should == 1
  end
  
  it "should find some bomb plants" do
    csp = CStrikeParser.new(File.expand_path(File.dirname(__FILE__) + '/some_plants.log'))
    sessions = csp.parse!
    
    sessions[0].rounds[0].bomb_plants.size.should == 2
  end
  
  it "should find some bomb defusals" do
    csp = CStrikeParser.new(File.expand_path(File.dirname(__FILE__) + '/some_defusals.log'))
    sessions = csp.parse!
    
    sessions[0].rounds[0].bomb_defusals.size.should == 6
    sessions[0].rounds[0].bomb_defusals.all(:successful => true).size.should == 3
    sessions[0].rounds[0].bomb_defusals.all(:with_kit => true).size.should == 2
    sessions[0].rounds[0].bomb_defusals.all(:with_kit => true, :successful => true).size.should == 2
  end
  
end 
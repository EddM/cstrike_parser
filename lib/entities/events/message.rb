class Message 
  include DataMapper::Resource

  Expression = Regexp.new('.*?<[^>]+>(<STEAM_[^>]+>).*?(say_team|say).*?(".*?").*?(dead|.*)?', Regexp::IGNORECASE)

  property :id, Serial
  property :timestamp, DateTime
  property :contents, String, :length => 255
  property :private, Boolean
  property :alive, Boolean

  belongs_to :player
  belongs_to :round
  
  def self.alive
    all(:alive => true)
  end
  
  def self.dead
    all(:alive => false)
  end
  
  def self.private
    all(:private => true)
  end
  
  def self.public
    all(:private => false)
  end
  
  def self.accusations
    all(:conditions => ["contents LIKE ? OR contents LIKE ? OR contents LIKE ? OR contents LIKE ? OR contents LIKE ? OR contents LIKE ?", "%bullshit%", "%cheat%", "%walls%", "%wallhack%", "%16bit%", "%chet%"])
  end
  
end
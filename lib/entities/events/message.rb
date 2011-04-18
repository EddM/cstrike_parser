class Message 
  include DataMapper::Resource

  Expression = Regexp.new('.*?<[^>]+>(<[^>]+>).*?(say_team|say).*?(".*?").*?(dead|.*)?', Regexp::IGNORECASE)

  property :id, Serial
  property :timestamp, DateTime
  property :contents, String
  property :private, Boolean
  property :alive, Boolean

  belongs_to :player
  belongs_to :round
  
end
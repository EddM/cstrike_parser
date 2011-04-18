class Session
  include DataMapper::Resource

  property :id, Serial
  property :started_at, DateTime
  property :ended_at, DateTime

  has n, :rounds
  has n, :players

end
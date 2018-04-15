class User
  include Cequel::Record

  key :id, :uuid
  has_many :images
end

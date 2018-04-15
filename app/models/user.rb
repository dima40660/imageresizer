class User
  include Cequel::Record

  key :id, :uuid, auto: true
  has_many :images
end

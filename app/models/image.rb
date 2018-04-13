class Image
  include Cequel::Record

  belongs_to :image
  key :id, :uuid, auto: true
  column :name, :text
  column :base64, :text
  column :meta_info, :text
  has_many :image
end

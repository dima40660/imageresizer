require "mini_magick"
class Image
  include Cequel::Record

  belongs_to :user
  key :id, :uuid
  column :name, :text
  column :file, :blob
  column :meta_info, :text
  has_many :images

  def resize(height, width)
    image = MiniMagick::Image.open(file)
    image.resize(height + "x" + width)
  end
end

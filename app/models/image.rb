require "mini_magick"
class Image
  include Cequel::Record

  belongs_to :user
  key :id, :uuid, auto: true
  column :name, :text
  column :file, :blob
  has_many :images

  def resize(height, width)
    image = MiniMagick::Image.read(file)
    image.resize(height.to_s + "x" + width.to_s)
  end

  def self.generate_name(original_name,  new_width, new_height)
    regex = /\.[^\.]\w*\z/
    splited = original_name.split(regex)
    splited.first + "_" + new_width.to_s + "x" + new_height.to_s + regex.match(original_name).to_s
  end
end

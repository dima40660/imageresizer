require "mini_magick"
class Image
  include Cequel::Record

  belongs_to :user
  key :id, :uuid, auto: true
  column :name, :text
  column :file, :blob
  has_many :images

  def create_resized(resize_image_params)
    resized = resize(resize_image_params)
    Image.create(user_id: user_id,
                 file: resized.to_blob,
                 name: generate_name(resize_image_params))
  end

  private

  def resize(params)
    image = MiniMagick::Image.read(file)
    image.resize("#{params[:width].to_s}x#{params[:height].to_s}")
  end

  def generate_name(params)
    regex = /\.[^\.]\w*\z/
    splited = name.split(regex)
    "#{splited.first}_#{params[:width].to_s}x#{params[:height].to_s}#{regex.match(name).to_s}"
  end
end

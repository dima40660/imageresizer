require "mini_magick"
class Image
  include Cequel::Record

  belongs_to :user
  key :id, :uuid, auto: true
  column :name, :text
  column :file, :blob
  column :meta_info, :text
  has_many :images

  def self.get_meta_info(file)
    image = MiniMagick::Image.read(file)
    {width: image.width, height: image.height}.to_json
  end

  def create_resized(resize_image_params)
    resized = resize(resize_image_params)
    Image.create(user_id: user_id,
                 file: resized.to_blob,
                 name: generate_name(resize_image_params),
                 meta_info: {width: resize_image_params[:width],
                             height: resize_image_params[:height]}.to_json
    )
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

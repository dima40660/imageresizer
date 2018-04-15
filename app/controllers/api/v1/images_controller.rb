class Api::V1::ImagesController < BaseController
  include ImagesHelper

  def create
    image = current_user.images.create(id: SecureRandom.uuid,
                                       name: params[:image].original_filename,
                                       file: params[:image].read)
    render json: {image_url: api_v1_image_path(image.id)}
  end

  def show
    image = @current_user.images.find_by_id(params[:id])
    if image
      send_data(image.file)
    else
      render json:{}, status: :no_content
    end
  end

  def destroy
    image = Image.find_by(id: params[:id])
    image.delete
    render json: {}
  end

  def resize
    image = Image.find_by(id: params[:image_id])
    resized = image.resize(params[:height], params[:width])
    image.images.create(resized)
  end

  def get_user_images

  end
end

class Api::V1::ImagesController < BaseController

  include ImagesDoc

  def index
    render json: { images: @current_user.images.map{|image| {file_name: image.name,
                                                              image_id: image.id.to_s,
                                                              image_url: api_v1_image_path(image.id)}}}
  end

  def create
    if create_image_params
      image = @current_user.images.create(name: create_image_params.original_filename,
                                          file: create_image_params.read)
      render json: {image_url: api_v1_image_path(image.id)}
    else
      render json: {}, status: :bad_request
    end

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
    image = @current_user.images.find_by_id(params[:id])
    if image
      image.destroy
    else
      render json: {}, status: :no_content
    end

  end

  def resize
    if resize_image_params
      image = @current_user.images.find_by_id(resize_image_params[:id])
      if image
        resized = image.create_resized(resize_image_params)
        render json: {image_url: api_v1_image_path(resized.id)}
      else
        render json:{}, status: :no_content
      end
    else
      render json:{}, status: :bad_request
    end
  end

  private

  def create_image_params
    if params.has_key?(:image)
      params.require(:image)
    end
  end

  def resize_image_params
    if params.has_key?(:image)
      params.require(:image).permit(:id, :width, :height)
    end
  end
end

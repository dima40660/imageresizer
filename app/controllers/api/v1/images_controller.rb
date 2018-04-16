class Api::V1::ImagesController < BaseController

  def create
    image = @current_user.images.create(id: SecureRandom.uuid,
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
    image = @current_user.images.find_by_id(id: params[:id])
    image.delete
    render json: {}
  end

  def resize
    image = @current_user.images.find_by_id(params[:image_id])
    if image
      resized = image.resize(params[:height], params[:width])
      new_image = @current_user.images.create(id: SecureRandom.uuid,
                          file: resized.to_blob,
                          name: Image.generate_name(image.name, params[:width].to_s, params[:height].to_s))
      render json: {image_url: api_v1_image_path(new_image.id)}
    else
      render json:{}, status: :no_content
    end
  end

  def index
    render json: { images: [@current_user.images.map{|image| {file_name: image.name,
                                                              image_id: image.id.to_s,
                                                              image_url: api_v1_image_path(image.id)
          }
        }
      ]
    }
  end
end

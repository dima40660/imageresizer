class Api::V1::ImagesController < BaseController
  include ImagesHelper

  def create
    data = parse_image(params[:image])
    image = Image.create(base64: data)
    render json: {id: image.id}
  end

  def show
    image = Image[params[:id]]
    render json: {image: image.base64}
  end

  def destroy
    image = Image.find_by(id: params[:id])
    image.delete
    render json: {}
  end

end

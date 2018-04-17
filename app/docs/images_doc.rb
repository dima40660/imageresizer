module ImagesDoc
  extend Apipie::DSL::Concern

  api :GET, 'api/v1/images/', 'Return list of user images'
  header 'user-id', "This header is needed for receiving user resources", :required => true
  example '
  {
	"images": [
		{
			"file_name": "BMW-4-series-gran-coupe-images-and-videos-1920x1200-10.jpg.asset.1487328157424.jpg",
			"image_id": "1fc6b694-4225-11e8-9e7a-21fcde9aa8fd",
			"image_url": "/api/v1/images/1fc6b694-4225-11e8-9e7a-21fcde9aa8fd",
			"meta_info": {
				"width": 1920,
				"height": 1200
			}
		},
		{
			"file_name": "BMW-4-series-gran-coupe-images-and-videos-1920x1200-10.jpg.asset.1487328157424_100x100.jpg",
			"image_id": "6667c796-4225-11e8-9e7a-21fcde9aa8fd",
			"image_url": "/api/v1/images/6667c796-4225-11e8-9e7a-21fcde9aa8fd",
			"meta_info": {
				"width": 100,
				"height": 100
			}
		}
	]
}'
  def index; end

  api :GET, 'api/v1/images/:id', 'Return single image'
  param :id, String, required: true
  header 'user-id', "This header is needed for receiving user resources", :required => true
  example '{ "some_blob_data (image file)" }'
  def show; end

  api :POST, 'api/v1/images/', 'Create new image for user'
  error code: 400, desc: 'Bad request'
  header 'user-id', "You can create image without this header, but you need it in future for getting user content. You can get it from responce headers.", :required => false
  example '
  {
	"image": {
		"url": "/api/v1/images/1fc6b694-4225-11e8-9e7a-21fcde9aa8fd",
		"name": "BMW-4-series-gran-coupe-images-and-videos-1920x1200-10.jpg.asset.1487328157424.jpg",
		"id": "1fc6b694-4225-11e8-9e7a-21fcde9aa8fd",
		"meta_info": "{\"width\":1920,\"height\":1200}"
	}
}'
  def create; end

  api :POST, 'api/v1/resize/', 'Resize image'
  error code: 400, desc: 'Bad request'
  error code: 204, desc: 'No content'
  param :image, Hash, required: true do
    param :id, String, required: true
    param :width, String, required: true
    param :height, String, required: true
  end
  header 'user-id', "Image can be resized only if it already created for this user.", :required => true
  example '
  {
	"image": {
		"url": "/api/v1/images/806607c0-4225-11e8-9e7a-21fcde9aa8fd",
		"id": "806607c0-4225-11e8-9e7a-21fcde9aa8fd",
		"name": "BMW-4-series-gran-coupe-images-and-videos-1920x1200-10.jpg.asset.1487328157424_200x200.jpg",
		"meta_info": {
			"width": 200,
			"height": 200
		}
	}
}'
  def resize; end

  api :DELETE, 'api/v1/images/:id', 'Delete user image'
  error code: 204, desc: 'No content'
  param :id, String, required: true
  header 'user-id', "This header is needed for working with user resources", :required => true
  def destroy; end
end
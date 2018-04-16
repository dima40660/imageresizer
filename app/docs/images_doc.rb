module ImagesDoc
  extend Apipie::DSL::Concern

  api :GET, 'api/v1/images/', 'Return list of user images'
  header 'user-id', "This header is needed for receiving user resources", :required => true
  example '
  {
    "images": [
      [
        {
          "file_name": "pexels-photo_50x50.jpg",
          "image_id": "9f7540a5-721a-48c0-bb54-f88ccf8d77a2",
          "image_url": "/api/v1/images/9f7540a5-721a-48c0-bb54-f88ccf8d77a2"
        },
        {
          "file_name": "pexels-photo.jpg",
          "image_id": "df60a507-e255-4481-88c5-d9bc34046b16",
          "image_url": "/api/v1/images/df60a507-e255-4481-88c5-d9bc34046b16"
        }
      ]
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
  example '{ "image_url": "/api/v1/images/9f7540a5-721a-48c0-bb54-f88ccf8d77a2" }'
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
  example '{ "image_url": "/api/v1/images/df60a507-e255-4481-88c5-d9bc34046b16" }'
  def resize; end

  api :DELETE, 'api/v1/images/:id', 'Delete user image'
  error code: 204, desc: 'No content'
  param :id, String, required: true
  header 'user-id', "This header is needed for working with user resources", :required => true
  example '{}'
  def destroy; end
end
module ImagesDoc
  extend Apipie::DSL::Concern

  api :GET, '/api/v1/images/', 'Return list of user images'
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

end
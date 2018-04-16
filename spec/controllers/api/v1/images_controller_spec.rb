require 'rails_helper'

describe Api::V1::ImagesController, type: :controller do

  before :each do
    @file = fixture_file_upload("#{Rails.root}/spec/resources/min.jpg", 'image/jpg')
    @second_file = fixture_file_upload("#{Rails.root}/spec/resources/s7.jpg", 'image/jpg')
    @user = User.create
    @user_image = @user.images.create(name: @file.original_filename,
                                      file: @file.read)
  end

  describe "show image list" do
    it "should return all images for current_user" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers
      get :index
      expect(response).to have_http_status(:success)
      expect(response.body).to eq({images: [{file_name: "min.jpg", image_id: @user_image.id.to_s, image_url: api_v1_image_path(@user_image.id)}]}.to_json)
    end

    it "should not return images from other users" do
      @second_user = User.create
      @second_user_image = @second_user.images.create(name: @second_file.original_filename,
                                                      file: @second_file.read)

      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers
      get :index
      expect(response).to have_http_status(:success)
      expect(response.body).to eq({images: [{file_name: "min.jpg", image_id: @user_image.id.to_s, image_url: api_v1_image_path(@user_image.id)}]}.to_json)
    end
  end

  describe "create image" do
    it "should return success on creating image" do
      post :create, params: { image: @file }, format: :json
      expect(response).to have_http_status(:success)
    end

    it "saves image to database" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      post :create, params: { image: @second_file }, format: :json
      database_image = @user.images.find_by_id(JSON.parse(response.body)["image_url"].split('/').last)
      expect(database_image).to be_present
    end

    it "returns valid image url" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      post :create, params: { image: @second_file }, format: :json
      get :show, params: {id: JSON.parse(response.body)["image_url"].split('/').last}
      expect(response).to have_http_status(:success)
    end

    it "returns bad data if no image file" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      post :create, params: {}, format: :json
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "show image" do
    it "returns success on valid user-id and image_id" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      get :show, params: {id: @user_image.id.to_s}
      expect(response).to have_http_status(:success)
    end

    it "returns file on valid user-id and image_id" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      get :show, params: {id: @user_image.id.to_s}
      expect(response.body).to be_present
    end

    it "returns no content on invalid image_id" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      get :show, params: {id: SecureRandom.uuid}
      expect(response).to have_http_status(:no_content)
    end

    it "return no content on invalid user-id" do
      headers = {"user-id" => SecureRandom.uuid}
      request.headers.merge! headers

      get :show, params: {id:  @user_image.id.to_s}
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "delete image" do
    it "returns success on valid user-id and image_id" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      delete :destroy, params: {id: @user_image.id.to_s}
      expect(response).to have_http_status(:success)
    end

    it "remove image from database on valid user-id and image_id" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      delete :destroy, params: {id: @user_image.id.to_s}
      expect(@user.images.find_by_id(@user_image.id.to_s)).not_to be_present
    end

    it "returns no content on invalid image_id" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      delete :destroy, params: {id: SecureRandom.uuid}
      expect(response).to have_http_status(:no_content)
    end

    it "returns no content on invalid user-id" do
      headers = {"user-id" => SecureRandom.uuid}
      request.headers.merge! headers

      delete :destroy, params: {id: @user_image.id.to_s}
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "resize" do
    it "returns success on valid params" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      post :resize, params: {image: {id: @user_image.id.to_s, width: 100, height: 100}}
      expect(response).to have_http_status(:success)
    end

    it "returns resized image url on valid params" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      post :resize, params: {image: {id: @user_image.id.to_s, width: 100, height: 100}}
      expect(JSON.parse(response.body)["image_url"]).to be_present
    end

    it "creates resized image in database" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      post :resize, params: {image: {id: @user_image.id.to_s, width: 100, height: 100}}
      resized_image = @user.images.find_by_id(JSON.parse(response.body)["image_url"].split('/').last)
      expect(resized_image).to be_present
    end

    it "returns no content on invalid image_id" do
      headers = {"user-id" => @user.id.to_s}
      request.headers.merge! headers

      post :resize, params: {image: {id: SecureRandom.uuid, width: 100, height: 100}}
      expect(response).to have_http_status(:no_content)
    end

    it "returns no content on invalid user-id" do
      headers = {"user-id" => SecureRandom.uuid}
      request.headers.merge! headers

      post :resize, params: {image: {id: @user_image.id.to_s, width: 100, height: 100}}
      expect(response).to have_http_status(:no_content)
    end

    it "returns bad request on invalid params" do
      post :resize, params: {}
      expect(response).to have_http_status(:bad_request)
    end
  end

end
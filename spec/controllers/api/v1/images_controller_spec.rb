require 'rails_helper'

describe Api::V1::ImagesController, type: :controller do

  describe "Create image" do
    it "should return success on creating image" do
      post :create, params: { image: {original_filename:"test.jpg"}}, format: :json
      expect(response).to have_http_status(:success)
    end
  end

end
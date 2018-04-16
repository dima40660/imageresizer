require 'rails_helper'

describe Image, type: :model do

  before :each do
    @file = File.open("#{Rails.root}/spec/resources/min.jpg")
    @user = User.create
    @user_image = @user.images.create(name: "min.jpg",
                                      file: @file.read)
  end

  describe "resize" do
    it "should return resized file on valid params" do
      resized = @user_image.send(:resize, {width: 100, height: 100})
      expect(resized).to be_present
    end
  end

  describe "generate name" do
    it "should return new name" do
      new_name = @user_image.send(:generate_name, {width: 100, height: 100})
      expect(new_name).to eq("min_100x100.jpg")
    end
  end

  describe "create resized" do
    it "should create resized image" do
      resized = @user_image.create_resized({width: 100, height: 100})
      expect(resized.name).to eq("min_100x100.jpg")
      expect(resized.file).to be_present
    end
  end
end
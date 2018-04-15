class BaseController < ApplicationController
  before_action :set_user, :authorize
  after_action :add_user_id_to_headers


  def current_user
    if @current_user_id
      @current_user = User.find_by_id(@current_user_id)
    end
  end

  private
  def authorize
    if !@user_id || !User.find_by_id(@user_id)
      @current_user = User.create(id: SecureRandom.uuid)
      @current_user_id = @current_user.id
    end
  end

  def set_user
    @current_user_id = request.headers["user-id"]
    @current_user = current_user
  end

  def add_user_id_to_headers
    response.set_header("user-id", @current_user_id)
  end

end
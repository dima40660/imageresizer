module ImagesHelper

  def parse_image(data)
    begin
      parse_data = Base64.decode64(data[data.index(',')+1 .. -1])
    rescue
      parse_data = nil
    end
    return parse_data
  end

end

class GetDataJson
  def call
    request_data
  end

  private

  def request_data
    RestClient.get 'https://test-frontend-developer.s3.amazonaws.com/data/locations.json'
  end
end

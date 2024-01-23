class GooglePlacesAPI
  def initialize(query)
    @query = query
  end

  def perform_search
    url = URI.parse('https://places.googleapis.com/v1/places:searchText')

    data = {
      textQuery: @query,
      maxResultCount: 3,
      languageCode: 'ja'
    }

    headers = {
      'Content-Type' => 'application/json',
      'X-Goog-Api-Key' => Rails.application.credentials.googlemap[:api_key],
      'X-Goog-FieldMask' => 'places.displayName,places.formattedAddress,places.id,places.location'
    }

    http = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https')
    request = Net::HTTP::Post.new(url.path, headers)
    request.body = data.to_json

    response = http.request(request)
    http.finish

    if response.code.to_i == 200
      JSON.parse(response.body)
    else
      { error: 'Request failed' }
    end
  end
end

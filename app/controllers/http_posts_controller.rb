class HttpPostsController < ApplicationController
  def http_post
    result_data = GooglePlacesAPI.new(params[:textQuery]).perform_search
    api_key = Rails.application.credentials.googlemap[:api_key]

    if result_data.key?('error')
      render json: { success: false, error: result_data['error'] }
    else
      render json: { success: true, data: result_data, apikey: api_key }
    end
  end
end

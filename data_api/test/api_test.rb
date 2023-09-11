require 'minitest/autorun'
require 'rack/test'
require 'net/http'
require_relative '../api'

class APITest < Minitest::Test
  include Rack::Test::Methods

  def app
    API.new({})  # Instantiate your Roda app here
  end

  def uri(url)
    URI("http://localhost:9292/#{url}")
  end

  def send_http_request(url)
    Net::HTTP.get_response(uri(url))
  end

  def test_summary_end_point
    url = 'summary'
    response = send_http_request(url)
  
    assert response.code.to_i.eql?(200) # success
    response_data = JSON.parse(response.body)
    assert response_data.key?('policies')
    assert response_data.key?('carriers')
    assert response_data.key?('clients')

    url = 'summarize'
    response = send_http_request(url)
    assert response.code.to_i.eql?(404) # failure
  end

  def test_clients_end_pint
    url = 'clients'
    response = send_http_request(url)
  
    assert response.code.to_i.eql?(200) # succcess

    assert JSON.parse(response.body)['count'].eql?(50)
  end

  def test_client_end_point
    url = 'clients/5'
    response = send_http_request(url)
    
    assert response.code.to_i.eql?(200) # success

    assert JSON.parse(response.body)['id'].eql?(5) 

    url = 'clients/0'
    response = send_http_request(url)
    assert response.code.to_i.eql?(500) # failure
  end

  def test_upload_end_point
    url = URI('http://localhost:9292/upload')
    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'

    boundary = '----WebKitFormBoundary7MA4YWxkTrZu0gW'

    file_path = '../data/part_3_encryption/ClientUpdates.csv.gpg'

    request.body = <<~MULTIPART
      --#{boundary}\r
      Content-Disposition: form-data; name="file"; filename="ClientUpdates.csv.gpg"\r
      Content-Type: application/octet-stream\r
      \r
      #{File.read(file_path)}\r
      --#{boundary}--\r
    MULTIPART

    http = Net::HTTP.new(url.host, url.port)
    response = http.request(request)

    assert response.code.to_i.eql?(200)
    assert JSON.parse(response.body)['message'].eql?("File is being processed in the background")
  end
end
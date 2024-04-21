require "net/http"

class ApplicationClient
  class Error < StandardError; end

  BASE_URI = "https://test.example.org"

  attr_reader :token

  def initialize(token:)
    @token = token
  end

  private

  def default_headers
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }
  end

  def get(path, headers: {}, query: nil)
    make_request(
      klass: Net::HTTP::Get,
      path: path,
      headers: headers,
      query: query
    )
  end

  def delete(path, headers: {})
    make_request(
      klass: Net::HTTP::Delete,
      path: path,
      headers: headers
    )
  end

  def base_uri
    self.class::BASE_URI
  end

  # Makes an HTTP request
  #   `klass` should be a Net::HTTP::Request class such as Net::HTTP::Get
  #   `path` is a String for the URL path without the protocol and domain. For example: "/api/v1/info"
  def make_request(klass:, path:, headers: {}, body: nil, query: nil)
    uri = URI("#{base_uri}#{path}")

    # Merge query params with any currently in `path`
    existing_params = Rack::Utils.parse_query(uri.query)
    uri.query = Rack::Utils.build_query(existing_params.merge(query || {}))

    Rails.logger.debug("#{klass.name.split("::").last.upcase}: #{uri}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.instance_of? URI::HTTPS

    request = klass.new(uri.request_uri, default_headers.merge(headers))
    request.body = build_body(body) if body.present?

    handle_response(http.request(request))
  end

  def handle_response(response)
    case response.code
    when "200", "201", "202", "203", "204"
      parse_response(response) if response.body.present?
    else
      raise Error, "#{response.code} - #{response.body}"
    end
  end

  def build_body(body)
    case body
    when String
      body
    else
      body.to_json
    end
  end

  def parse_response(response)
    JSON.parse(response.body, object_class: OpenStruct)
  end
end

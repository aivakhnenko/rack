require_relative 'date_formatter'

class App
  DEFAULT_HEADER = { 'Content-Type' => 'text/plain' }.freeze

  def call(env)
    request = Rack::Request.new(env)
    return respond_invalid_request unless valid_request?(request)

    formats = parse_formates(request)
    formatter = DateFormatter.new(formats)

    return respond_invalid_formats(formatter.invalid_formats) unless formatter.valid_formats?
    respond_date(formatter.date)
  end

  private

  def valid_request?(request)
    request.get? && request.path == '/time'
  end

  def parse_formates(request)
    query_string = request.query_string
    query_params = Rack::Utils.parse_nested_query(query_string)
    format_param = query_params['format']
    format_param.split(',')
  end

  def respond_invalid_request
    make_response(404, 'Not found')
  end

  def respond_date(date_string)
    make_response(200, date_string)
  end

  def respond_invalid_formats(invalid_formats)
    invalid_formats_string = invalid_formats.join(', ')
    make_response(400, "Unknown time format [#{invalid_formats_string}]")
  end

  def make_response(code, body)
    [
      code, 
      DEFAULT_HEADER, 
      ["#{body}\n"]
    ]
  end
end

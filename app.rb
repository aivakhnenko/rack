require_relative 'date_format'

class App
  def call(env)
    request = Rack::Request.new(env)
    return respond_invalid_request unless valid_request?(request)
    formats = parse_formates(request)
    date = DateFormat.new(formats)
    return respond_invalid_formats(date.invalid_formats) unless date.valid_formats?
    return respond_date(date.date)
  end

  private

  def valid_request?(request)
    valid_request_method?(request) && valid_request_path?(request)
  end

  def valid_request_method?(request)
    request.get?
  end

  def valid_request_path?(request)
    request.path == '/time'
  end

  def respond_invalid_request
    [
      404, 
      default_header, 
      ["Not found\n"]
    ]
  end

  def parse_formates(request)
    query_string = request.query_string
    query_params = Rack::Utils.parse_nested_query(query_string)
    format_param = query_params['format']
    format_param.split(',')
  end

  def respond_date(date_string)
    [
      200, 
      default_header, 
      ["#{date_string}\n"]
    ]
  end

  def respond_invalid_formats(invalid_formats)
    invalid_formats_string = invalid_formats.join(', ')
    [
      400, 
      default_header, 
      ["Unknown time format [#{invalid_formats_string}]\n"]
    ]
  end

  def default_header
    { 'Content-Type' => 'text/plain' }
  end
end

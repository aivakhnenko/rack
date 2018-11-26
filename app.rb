class App
  def call(env)
    return invalid_request(env) unless valid_request?(env)
    formats = parse_formates(env)
    return invalid_formats(formats) unless valid_formats?(formats)
    return processed_date(formats)
  end

  private

  VALID_FORMATS = ['year', 'month', 'day', 'hour', 'minute', 'second'].freeze

  def valid_request?(env)
    valid_request_method?(env) && valid_request_path?(env)
  end

  def valid_request_method?(env)
    env['REQUEST_METHOD'] == 'GET'
  end

  def valid_request_path?(env)
    env['REQUEST_PATH'] == '/time'
  end

  def invalid_request
    [
      404, 
      default_header, 
      ["Not found\n"]
    ]
  end

  def parse_formates(env)
    query_string = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
    format_param = query_string['format']
    format_param.split(',')
  end

  def valid_formats?(formats)
    (formats - VALID_FORMATS).empty?
  end

  def invalid_formats(formats)
    invalid_formats_string = (formats - VALID_FORMATS).join(', ')
    [
      400, 
      default_header, 
      ["Unknown time format [#{invalid_formats_string}]\n"]
    ]
  end

  def processed_date(formats)
    date_array = formats.map{ |format| process_format(format) }
    date = date_array.join('-')
    [
      200, 
      default_header, 
      ["#{date}\n"]
    ]
  end

  def process_format(format)
    time = Time.now
    case format
    when 'year' then time.year
    when 'month' then time.month.to_s.rjust(2, '0')
    when 'day' then time.day.to_s.rjust(2, '0')
    when 'hour' then time.hour.to_s.rjust(2, '0')
    when 'minute' then time.min.to_s.rjust(2, '0')
    when 'second' then time.sec.to_s.rjust(2, '0')
    end
  end

  def default_header
    { 'Content-Type' => 'text/plain' }
  end
end

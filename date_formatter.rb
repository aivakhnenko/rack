class DateFormatter
  FORMATS_TO_ACTIONS = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }.freeze

  def initialize(formats)
    @formats = formats.map(&:to_sym)
  end

  def valid_formats
    FORMATS_TO_ACTIONS.keys
  end

  def valid_formats?
    invalid_formats.empty?
  end

  def invalid_formats
    @formats - valid_formats
  end

  def date
    raise 'Invalide format' unless valid_formats?
    actions_array = @formats.map{ |format| format_to_action(format) }
    actions_string = actions_array.join('-')
    Time.now.strftime(actions_string)
  end

  private

  def format_to_action(format)
    FORMATS_TO_ACTIONS[format.to_sym]
  end
end

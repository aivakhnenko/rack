class DateFormat
  VALID_FORMATS = %w[year month day hour minute second].freeze

  def initialize(formats)
    @formats = formats
  end

  def valid_formats?
    invalid_formats.empty?
  end

  def invalid_formats
    @formats - VALID_FORMATS
  end

  def date
    raise 'Invalide format' unless valid_formats?
    date_array = @formats.map{ |format| process_format(format) }
    date_array.join('-')
  end

  private

  def process_format(format)
    action =
      case format
      when 'year' then '%Y'
      when 'month' then '%m'
      when 'day' then '%d'
      when 'hour' then '%H'
      when 'minute' then '%M'
      when 'second' then '%S'
      end
    Time.now.strftime(action)
  end
end

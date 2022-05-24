class DateParser
  MONTHS = {
    "января"    => "january",
    "февраля"   => "february",
    "марта"     => "march",
    "апреля"    => "april",
    "мая"       => "may", 
    "июня"      => "june", 
    "июля"      => "july",
    "августа"   => "august",
    "сентября"  => "september",
    "октября"   => "october",
    "ноября"    => "november",
    "декабря"   => "december"
  }

  def initialize(date:, time_zone:)
    @time_zone = time_zone
    @date = date
  end

  def call
    Time.find_zone(@time_zone).parse(
      @date.sub(/[а-я]+/, MONTHS)
    )
  end
end
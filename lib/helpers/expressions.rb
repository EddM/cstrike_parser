module Helpers
  module Expressions

    TimestampExpression = Regexp.new('(L).*?([0-9][0-9]).*?(\\/)([0-9][0-9]).*?(\\/)((?:(?:[1]{1}\\d{1}\\d{1}\\d{1})|(?:[2]{1}\\d{3})))(?![\\d]).*?(-).*?([0-9][0-9]).*?(:)([0-9][0-9]).*?(:)([0-9][0-9]).*?(:)', Regexp::IGNORECASE)

    SessionExpression = /Log file started/

  end
end
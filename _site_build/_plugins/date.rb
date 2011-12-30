module Jekyll
  module DateFilter
    def ordinalize(date)
      day = date.day
      if (11..13).include?(day % 100)
        "#{day}th"
      else
        case day % 10
          when 1; "#{day}st"
          when 2; "#{day}nd"
          when 3; "#{day}rd"
          else    "#{day}th"
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::DateFilter)

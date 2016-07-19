# Working time list
class TimeSheet
  def initialize
    @entries = []
    # @workdays = {}
    # start_date.upto(Date.today) do |date|
    #   @workdays[date.to_s] = [] if date.cwday < 6
    # end
  end

  def add(id, date, description, hours)
    #start_date = date.to_s[0..9]
    @entries << {
      id: id,
      description: description,
      date: date.to_date,
      hours: hours
    }
  end

  def calculated_entries
    result = []
    entries = @entries.sort_by { |h| h[:id] }

    # require 'pry'; binding.pry

    entries.each_with_index do |current, i|
      current_date = current[:date]
      if current[:hours] < 8
        result << {
          date: current[:date].to_s,
          description: current[:description],
          time: '17:00:00',
          duration: "#{current[:hours]}:00:00"
        }
        next
      elsif i == 0
        previous_date = entries[0][:date]
      else
        previous = entries[i - 1]
        previous_date = previous[:date]
        previous_date = previous_date.next_day if previous[:hours] > 5
      end

      current_date.downto(previous_date) do |date|
        # skip weekends
        next unless date.cwday < 6
        result << {
          date: date.to_s,
          description: current[:description],
          time: '9:00:00',
          duration: '7:00:00'
        }
      end
    end

    result.sort_by { |h| h[:date] }
  end

end

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

    entries.each_with_index do |current, i|
      current_date = current[:date]
      if current[:hours] < 5
        result << {
          date: current[:date].to_s,
          description: current[:description],
          time: '%02d:%02d:00' % [Random.rand(9...12), Random.rand(0...59)],
          duration: '%02d:00:00' % current[:hours]
        }
        next
      end

      next_entry = entries[i + 1]

      if next_entry == nil
        next_date = current_date.next_day
      else
        next_date = next_entry[:date]
      end

      current_date.upto(next_date) do |date|
        # skip weekends
        next unless date.cwday < 6
        time_started = '%02d:%02d:00' % [Random.rand(9...12), Random.rand(0...59)]
        result << {
          date: date.to_s,
          description: current[:description],
          time: time_started,
          duration: '%02d:%02d:00' % [Random.rand(3...8), Random.rand(0...59)]
        }
      end
    end

    result.sort_by { |h| h[:date] }
  end

end

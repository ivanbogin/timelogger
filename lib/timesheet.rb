# Working time list
class TimeSheet
  attr_reader :entries

  def initialize
    @entries = {}
  end

  def add(id, date, description)
    @entries[id] = {
      id: id, date: date, description: description
    }
  end
end

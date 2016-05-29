class TimeSheet
  @entries = []

  def add_entry(datetime, description)
    @entries << {:date => datetime, :description => description}
  end
end

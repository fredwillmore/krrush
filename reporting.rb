class Report
  REPORT_DATA_LIMIT = 1000
  DATA_FILE_DIRECTORY = '/Users/fredwillmore/Documents/visualizer/'

  def initialize file
    @filename = file.nil? ? nil : "#{DATA_FILE_DIRECTORY}#{file}"
    @reporting = false
    @index = 0
  end

  def start
    @reporting = true
    @file = File.open @filename, 'w'
    write "x,y\n"
  end

  def stop
    if @reporting
      @reporting = false
      File.close @filename, 'w'
    end
  end

  def write data
    @file.write data if @reporting
  end

  def write_line data
    data = data.join ',' if data.is_a? Array
    write "#{@index},#{data}\n"
    @index += 1
    stop if @index > REPORT_DATA_LIMIT
  end

end

class Filer

  attr_accessor :filename

  def open(file)
    filename = file.getCanonicalPath
    f = File.open filename, "r"
    @filename = filename
    text = IO.readlines filename
    content = ''
    text.each{|x| content += x }
    content
  end

  def open_by_path(path)
    f = File.open path, "r"
    text = IO.readlines path
    content = ''
    text.each{|x| content += x }
    content
  end

  def save(file_name, area)
    File.open(file_name, 'w') do |f|
      f.puts area.getText
    end
  end

  def save_as(file, content)
    filename = file.getCanonicalPath
    File.open(filename, 'w') do |f|
      f.puts content
    end
  end

end

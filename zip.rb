class Archive
  def initialize(file)
    @tmp = 'tmp'
    @file = file
  end

  def isZip?
    @file.include?('.zip') ? true : false
  end

  def zip
    @zipFile = "#{@file}.zip"
    File.rename(@file, @tmp)
    `zip -r #{@tmp}.zip #{@tmp}`
    File.rename("#{@tmp}.zip", @zipFile)
  end

  def unzip
    `unzip "#{@file}"`
    dir = @file.gsub('.zip', '')
    File.rename(@tmp, dir)
    File.delete(@file)
  end

  def hasTag?
    /,,/ =~ @file ? true : false
  end

  def addTag
    file = @file.gsub('.zip', '')
    split = file.split(',,')
    tags = split.first
    title = split.last
    `tag --add #{tags} #{file}`
    File.rename(file, title)
  end

  def removeTag
    tags = `tag --no-name --list --tags #{@tmp}`.chomp
    @title = tags + ',,' + @zipFile
    File.rename(@zipFile, @title)
    removeDir(@tmp)
  end

  def removeDir(dir)
    Dir["#{dir}/*"].each do |image|
      File.delete(image)
    end
    Dir.delete(dir)
  end
end

Dir['*'].each do |file|
  unless /\.rb$/ =~ file
    f = Archive.new(file)
    f.isZip? ? f.unzip : f.zip
    f.hasTag? ? f.addTag : f.removeTag
  end
end


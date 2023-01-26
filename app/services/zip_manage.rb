require 'zip'

class ZipManage

  def initialize(file_path)
    @file_path = file_path
    @destination = File.dirname(file_path)
    output_file_name = SecureRandom.hex
    @output_file = "#{@destination}/#{output_file_name}.zip"
	end

  def unzip
    Zip::File.open(@file_path) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(@destination, f.name)
        target_dir = File.dirname(fpath)
        FileUtils.mkdir_p(target_dir) unless File.directory?(target_dir)
        zip_file.extract(f, fpath)
      end
    end
    File.delete(@file_path)
  end

  def zip
    Zip::File.open(@output_file, Zip::File::CREATE) do |zipfile|
      if File.directory?(@destination)
        Dir["#{@destination}/**/**"].each do |file|
          zipfile.add(file.sub(@destination + '/', ''), file)
        end
      else
        zipfile.add(File.basename(@destination), @destination)
      end
    end
  end

  def output_zip
    @output_file
  end
end
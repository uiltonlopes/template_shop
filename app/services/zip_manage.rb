require 'zip'

class ZipManage

  def initialize(zip_file, location_folder_name)
    @zip_file = zip_file
    @tmp_folder = location_folder_name
    FileUtils.mkdir_p(@tmp_folder) 
	end

  def unzip
    Zip::File.open(@zip_file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(@tmp_folder, f.name)
        target_dir = File.dirname(fpath)
        FileUtils.mkdir_p(target_dir) unless File.directory?(target_dir)
        zip_file.extract(f, fpath)
      end
    end
  end
end
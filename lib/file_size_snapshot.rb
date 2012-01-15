require 'disk_access_helper'

class FileSizeSnapshot

  def initialize(directory)
    @directory = directory
  end

  def files
    @files ||= [].tap do |files|
      du_data.each do |line|
        line << directory_list.include?(line[1])
        files << Hash[[:size, :path, :directory?].zip(line)]
      end
    end
  end

  def generate
    DiskAccessHelper.write_to_disk(files)
  end

  private

  def du_data
    @du_data ||= `command du -a #{@directory}`.split("\n").collect{|line| line.split("\t")}
  end

  def directory_list
    @directory_list ||= `command find #{@directory} -type d`.split("\n")
  end
end

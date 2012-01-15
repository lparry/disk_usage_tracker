require 'json'
require 'zip/zip'

class DiskAccessHelper
  def self.write_to_disk(data)
    Zip::ZipFile.open("#{timestamp}.zip", Zip::ZipFile::CREATE) do |zipfile|
      zipfile.get_output_stream("#{timestamp}.json") { |f| f.write(data.to_json) }
    end
  end

  def self.data_sets
    `command find . -name "*.zip"|sed -e 's/[^0-9]//g'`.split("\n")
  end

  def self.read(date)
    Zip::ZipFile.open("#{date}.zip", Zip::ZipFile::CREATE) do |zipfile|
      JSON.parse(zipfile.read("#{date}.json"))
    end
  end

  private

  def self.timestamp
    @timestamp ||= Time.now.strftime "%Y%m%d%H%M%S"
  end

end

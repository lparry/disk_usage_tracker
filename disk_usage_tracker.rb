
require 'rubygems'
require 'json'
require 'zip/zip'
require 'pry'

class FileSizeLookup

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

  private

  def du_data
    @du_data ||= `command du -ka #{@directory}`.split("\n").collect{|line| line.split("\t")}
  end

  def directory_list
    @directory_list ||= `command find #{@directory} -type d`.split("\n")
  end
end

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

class ChangeSet

  attr_reader :revision_a, :revision_b

  def initialize(revision_a, revision_b)
    @revision_a, @revision_b = revision_a, revision_b
  end

  def first_revision
    @first_revision ||= DiskAccessHelper.read(revision_a)
  end

  def second_revision
    @second_revision ||= DiskAccessHelper.read(revision_b)
  end

  def matched_files
    @data ||= {}.tap do |data|

      first_revision.each do |row|
        data[row["path"]] ||= {}
        data[row["path"]][revision_a] = row
      end

      second_revision.each do |row|
        data[row["path"]] ||={}
        data[row["path"]][revision_b] = row
      end

    end.values
  end

  def changes
    changed = []

    matched_files.each do |data|
      if data[revision_a] and data[revision_b]
        changed << data if data[revision_a]["size"] != data[revision_b]["size"]
      else
        changed << data
      end
    end

    changed
  end

  private

  def get_size(data, revision)
    if data[revision]
      data["size"]
    else
      0
    end
  end
end
#file_size_lookup = FileSizeLookup.new("~/Dropbox")
#puts DiskAccessHelper.data_sets
#
changes = ChangeSet.new("20120115120420","20120115122300")

binding.pry

# class UnixFile
#   attr_accessor :size, :path, :children, :filename
#
#   def initialize(args = {})
#     self.size     = args[:size] || args['size'] || raise("size required")
#     self.path     = args[:size] || args['path'] || raise("path required")
#     self.filename = File.basename(path)
#     self.path     = File.dirname(path)
#     self.children = args[:children] || []
#   end
#
#   def inspect
#     "#<#{self.class.name}: @filename=#{filename} @size=#{size} @children=#{children.collect(&:name).inspect}>"
#   end
#
#   def apply(files)
#     files.all?{|file| file =~ /^#{RegExp.escape(path)}/ } or raise "shits fucked"
#     stripped_files = files.collect{|file| binding.pry; file.split_path}
#   end
#
#   def split_path
#     path.split("/")
#   end
# end
#
# data = []
# `cat input.du.gz|zcat`.each_line do |line|
#   data << line.chomp.split("\t")
# end
#
# this_run = []
# data.sort!{|a,b| a[1].length <=> b[1].length }.each do |row|
#   p row
#   this_run.push UnixFile.new(Hash[%w[size path].zip(row)])
# end
#
# root = this_run.shift
# root.apply(this_run)
# binding.pry
# p ''

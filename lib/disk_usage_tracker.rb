require 'rubygems'

require 'file_size_snapshot'
require 'disk_access_helper'
require 'change_set'

require 'pry'

puts DiskAccessHelper.data_sets

changes = ChangeSet.new("20120115143229","20120115143608")


binding.pry

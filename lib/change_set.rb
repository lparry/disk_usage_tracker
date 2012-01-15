require 'disk_access_helper'
require 'change'

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

  def changes_by_size
    changes.sort do |a,b|
      Change.new(a[@revision_a], a[@revision_b]).raw_size <=> Change.new(b[revision_a], b[@revision_b]).raw_size
    end
  end

  def changes_by_percentage
    changes.sort do |a,b|
      Change.new(a[@revision_a], a[@revision_b]).percentage <=> Change.new(b[revision_a], b[@revision_b]).percentage
    end
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

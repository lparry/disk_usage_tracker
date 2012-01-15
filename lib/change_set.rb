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
      change = Change.new(data[revision_a], data[revision_b])
        changed << change if change.changed?
    end

    changed
  end

  def changes_by_size
    changes.sort do |a,b|
      b.raw_size <=> a.raw_size
    end
  end

  def changes_by_percentage
    changes.sort do |a,b|
      b.percentage <=> a.percentage
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

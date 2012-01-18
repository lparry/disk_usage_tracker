require 'change_set'
class ChangeSetPresenter
  def initialize(change_set)
    @change_set = change_set
  end

  def top_5_by_size
    puts "Top 5 by change in size"
    puts "======================="
    puts @change_set.changes_by_size[0..5].collect(&:inspect)
    puts ""
  end

  def top_5_by_percentage
    puts "Top 5 by change in percentage"
    puts "======================="
    puts @change_set.changes_by_percentage[0..5].collect(&:inspect)
    puts ""
  end

end

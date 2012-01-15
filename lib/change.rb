class Change
  def initialize(version_a, version_b)
    @version_a = version_a
    @version_b = version_b
  end

  def raw_size
    size_after - size_before
  end

  def percentage
    increase = (size_after - size_before).to_f/size_before
    if increase.infinite?
      increase
    else
      (increase * 100).to_i

    end

  end

  def changed?
    size_before != size_after
  end


  def size_before
    if @version_a
      @version_a["size"].to_i
    else
      0
    end
  end

  def size_after
    if @version_b
      @version_b["size"].to_i
    else
      0
    end
  end

  def inspect
    if new?
      %(#{common_inspect_string} "new?": true >)
    elsif deleted?
      %(#{common_inspect_string} "deleted?": true >)
    else
      %(#{common_inspect_string} "percentage": #{percentage}% >)
    end
  end

  def new?
    @version_a.nil? && @version_b
  end

  def deleted?
    @version_a && @version_b.nil?
  end

  private

  def common_inspect_string
    %(#<#{self.class.name}: "path"=>"#{@version_b["path"]}", "directory?"=>#{@version_b["directory?"]}}, "before": #{size_before}, "after": #{size_after}, "raw_size": #{raw_size},)
  end

  def either
    (@version_a || @version_b)
  end
end


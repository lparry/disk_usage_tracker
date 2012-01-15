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
    %(#<#{self.class.name}: "path"=>"#{either["path"]}", "directory?"=>#{either["directory?"]}}, "raw_size": #{raw_size}, "percentage": #{percentage}% >)
  end

  private

  def either
    (@version_a || @version_b)
  end
end


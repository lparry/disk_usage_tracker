class Change
  def initialize(version_a, version_b)
    @version_a = version_a
    @version_b = version_b
  end

  def raw_size
    size_after - size_before
  end

  def percentage
    (size_after - size_before).to_f/size_before
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
end


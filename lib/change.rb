class Change
  def initialize(version_a, version_b)
    @version_a = version_a
    @version_b = version_b
  end

  def raw_size
    after - before
  end

  def percentage
    (after - before).to_f/before
  end


  def before
    if @version_a
      @version_a["size"].to_i
    else
      0
    end
  end

  def after
    if @version_b
      @version_b["size"].to_i
    else
      0
    end
  end
end


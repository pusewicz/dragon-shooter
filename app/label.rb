class Label
  attr_accessor :x, :y, :text, :size_enum, :alignment_enum, :font, :r, :g, :b, :a

  def primitive_marker
    :label
  end
end

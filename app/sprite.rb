class Sprite
  attr_sprite
  # attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :tile_x,
  #               :tile_y, :tile_w, :tile_h, :flip_horizontally,
  #               :flip_vertically, :angle_anchor_x, :angle_anchor_y

  def initialize(options = {})
    options.each do |k, v|
      self.send("#{k}=", v)
    end
  end

  def width=(value)
    self.w = value
  end

  def height=(value)
    self.h = value
  end

  def width; w; end
  def height; h; end

  def primitive_marker
    :sprite
  end

  def rect
    [x, y, w, h]
  end
end

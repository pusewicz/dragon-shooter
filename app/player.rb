class Player
  include HasSprite

  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y

    @sprite = AnimatedSprite.new(x: x, y: y, w: 16, h: 24, start_at: 0, loops: true, number_of_sprites: 2, number_of_frames: 20, path: "sprites/ship-up-%d.png")
  end

  def move_left
    self.x -= 2
  end

  def move_right
    self.x += 2
  end
end

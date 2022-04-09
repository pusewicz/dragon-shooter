class Bullet
  include HasSprite

  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y

    @sprite = AnimatedSprite.new(x: x, y: y, w: 5, h: 5, start_at: 0, loops: true, number_of_sprites: 2, number_of_frames: 20, path: "sprites/bullet-%d.png")
  end

  def tick
    self.y -= 1
  end

  def remove!
    @remove = true
  end

  def remove?
    @remove || @y < (@sprite.h * -1)
  end
end

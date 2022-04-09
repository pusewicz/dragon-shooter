class Laser
  include HasSprite

  attr_accessor :x, :y, :speed

  def initialize(x, y)
    @x, @y = x, y
    @w = 5
    @h = 12

    @speed = 3

    @sprite = AnimatedSprite.new(x: x, y: y, w: @w, h: @h, start_at: 0, loops: true, number_of_sprites: 2, number_of_frames: 8, path: "sprites/laser-%d.png")
  end

  def tick
    self.y += speed
  end

  def remove!
    @remove = true
  end

  def remove?
    @remove || @y > 720
  end
end

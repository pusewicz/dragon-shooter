class Enemy
  include HasSprite

  attr_accessor :x, :y, :horizontal_speed, :vertical_speed, :direction

  def initialize
    @x = rand(256 - 16)
    @y = 180 + 16

    @horizontal_speed = 1
    @vertical_speed = 0.5

    @direction = rand(2) == 0 ? 1 : -1

    @sprite = AnimatedSprite.new(x: x, y: y, w: 16, h: 16, start_at: 0, loops: true, number_of_sprites: 2, number_of_frames: 20, path: "sprites/enemy-%d.png")
  end

  def shoot?
    @shoot
  end

  def tick(tick_count)
    @shoot = false
    move_down

    @shoot = rand(60) == 0

    self.x += direction * horizontal_speed

    if self.x <= 0 || self.x >= ((256 - 16))
      change_direction!
    end
  end

  def change_direction!
    @direction = -direction
  end

  def move_down
    self.y -= vertical_speed
  end

  def remove!
    @remove = true
  end

  def remove?
    @remove || @y < -sprite.h
  end
end

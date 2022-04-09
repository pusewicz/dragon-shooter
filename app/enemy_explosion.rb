class EnemyExplosion
  attr_reader :x, :y

  def initialize(x, y, tick_count)
    @tick_count = tick_count
    @x, @y = x, y
    @ticks = 0
    @black_smoke_image = "sprites/black-smoke-%d.png" % rand(25)
    @white_puff_smoke_image = "sprites/white-puff-%d.png" % rand(25)
    @explosion_image = "sprites/explosion-%d.png" % rand(9)
    @flash_image = "sprites/flash-%d.png" % rand(9)

    @animation_ticks = 90
  end

  def tick
    @ticks += 1
    @y -= 0.4
  end

  def sprites
    ary = []
    if @ticks >= 5
      ary << Sprite.new(x: x, y: y, w: 32, h: 32, path: @black_smoke_image, a: alpha(@animation_ticks - 5, 5))
    end
    if @ticks > 5 && @ticks < 20
      ary << Sprite.new(x: x, y: y, w: 32, h: 32, path: @explosion_image, a: alpha(15, 5))
    end
    if @ticks < 15
      # TODO: Fix the sprite width and height as each sprite has different dimensions
      ary << Sprite.new(x: x, y: y, w: 32, h: 32, path: @flash_image, a: alpha(15, 0))
    end
    ary
  end

  def remove?
    @ticks > @animation_ticks
  end

  private

  def alpha(frames, start)
    frame = (@tick_count + start).frame_index(120, 1, false)
    255 - (frame / frames) * 255
  end
end

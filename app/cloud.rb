class Cloud < Sprite
  def initialize(options = {})
    super

    self.width = 256
    self.height = 103

    @y = 720 + height
    @x = 0
    @speed = rand(10) + 1
    @flip_vertically = rand(2) == 0
    @flip_horizontally = rand(2) == 1
    @a = rand(255) + 1
  end

  def move_down
    @y -= @speed
  end

  def remove?
    @y < -@w
  end

  def path
    "sprites/clouds.png"
  end
end

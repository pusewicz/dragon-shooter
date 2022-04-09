module HasSprite
  attr_reader :sprite

  def sprite(x = self.x, y = self.y)
    @sprite.x = x
    @sprite.y = y
    @sprite
  end
end

class VersionLabel < Label
  def initialize(x, y)
    self.text = VERSION_STRING
    self.x = x
    self.y = y
    self.size_enum = 0
    self.alignment_enum = 0
    self.r, self.g, self.b = [255, 255, 255]
    self.a = 128
  end
end

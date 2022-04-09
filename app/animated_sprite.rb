class AnimatedSprite < Sprite
  attr_accessor :number_of_sprites, :number_of_frames, :loops, :start_at

  def path
    super % start_at.frame_index(number_of_sprites, number_of_frames, loops)
  end
end

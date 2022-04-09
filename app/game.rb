class Game
  attr_gtk

  attr_accessor :background_position, :background_height, :game_width, :game_height, :game_top_offset, :debug

  def initialize
    @game_width = 256
    @game_height = 180
    #@game_top_offset = game_height * 3
    @background_height = 272
    @background_width = 256
    @background_position = 0
    @player_width = 16
    @shoot_timer = 0
    @score = 0

    @lasers = []
    @bullets = []
    @clouds = []
    @enemies = []
    @enemy_explosions = []

    @player = Player.new(game_width / 2, 8)
    @wall = initialize_wall
    @version_label = VersionLabel.new(8, 720 - 8)
  end

  def debug?
    @debug == true
  end

  def keyboard
    args.keyboard
  end

  def tick
    @render_target = args.render_target(:main_screen)

    outputs.sounds << "music/Crash Landing.ogg" if state.tick_count == 1

    handle_keyboard_input

    @shoot_timer -= 1 unless @shoot_timer == 0

    move_background
    enemies_tick
    @lasers.each(&:tick)
    @bullets.each(&:tick)
    @enemy_explosions.each(&:tick)

    calculate_collisions

    render
  end

  private

  def render
    render_background

    @lasers.each do |bullet|
      @render_target.sprites << bullet.sprite
    end

    @bullets.each do |bullet|
      @render_target.sprites << bullet.sprite
    end

    @enemies.each do |enemy|
      @render_target.sprites << enemy.sprite
    end

    @wall.each do |wall|
      outputs.sprites << wall
    end

    @enemy_explosions.each do |explosion|
      explosion.sprites.each do |sprite|
        @render_target.sprites << sprite
      end
    end

    @render_target.sprites << @player.sprite

    outputs.sprites << {
      x: 0,
      y: 0,
      w: game_width * MULTIPLIER,
      h: game_height * MULTIPLIER,
      path: :main_screen,
      tile_w: game_width,
      tile_h: game_height,
      tile_x: 0,
      tile_y: game_height * 3
    }

    #outputs.sprites << {
      #x: grid.right.shift_left(game_width),
      #y: 0,
      #w: game_width,
      #h: game_height,
      #path: :main_screen
    #}

    render_labels
  end

  def render_labels
    if debug?
      outputs.labels << @version_label
      outputs.labels << [grid.left.shift_right(8), grid.top.shift_down(56), "Tick: #{state.tick_count}", 0, 0, 255, 255, 255, 128]
      outputs.labels << [grid.left.shift_right(8), grid.top.shift_down(80), "FPS: #{gtk.current_framerate}", 0, 0, 255, 255, 255, 128]
      outputs.labels << [grid.left.shift_right(8), grid.top.shift_down(32), "Sprites: #{outputs.sprites.size + @render_target.sprites.size}", 0, 0, 255, 255, 255, 128]
    end
    outputs.labels << [grid.right.shift_left(1280 - (game_width * MULTIPLIER) - 8), grid.top.shift_down(8), "Score: #{@score}", 0, 0, 255, 255, 255, 255]
  end

  def calculate_collisions
    @lasers.each do |bullet|
      @enemies.each do |enemy|
        if !bullet.remove? && bullet.sprite.rect.intersect_rect?(enemy.sprite.rect)
          bullet.remove!
          enemy.remove!
          @score += 1
          outputs.sounds << "sounds/explosion-0.wav"
          @enemy_explosions << EnemyExplosion.new(enemy.x - 8, enemy.y - 8, state.tick_count)
        end
      end
    end

    @bullets = @bullets.reject(&:remove?)
    @enemies = @enemies.reject(&:remove?)
    @lasers  = @lasers.reject(&:remove?)
    @enemy_explosions  = @enemy_explosions.reject(&:remove?)
  end

  def handle_keyboard_input
    if keyboard.right
      @player.move_right unless @player.x + (@player_width) >= game_width
    elsif keyboard.left
      @player.move_left unless @player.x <= 0
    end

    if keyboard.space
      if @shoot_timer == 0
        @lasers << Laser.new(@player.x + 5, @player.y + 16)
        outputs.sounds << "sounds/laser%d.wav" % (rand(3) + 1)
        @shoot_timer += 10
      end
    end
  end

  def enemies_tick
    if @enemies.empty?
      @enemies << Enemy.new
    end
    @enemies.each do |enemy|
      enemy.tick(state.tick_count)
      if enemy.shoot?
        @bullets << Bullet.new(enemy.x + 5, enemy.y - 5)
        outputs.sounds << "sounds/laser9.wav"
      end
    end
    @enemies.delete_if(&:remove?)
  end

  def initialize_wall
    size = 36 * MULTIPLIER

    rows = ((1280 - (game_width * MULTIPLIER)) / size) + 1
    columns = (720 / size) + 1

    walls = []

    rows.to_i.times do |row|
      columns.to_i.times do |column|
        walls << Sprite.new(x: (game_width * MULTIPLIER) + (row * size), y: 720 - (column * size), w: size, h: size, path: "sprites/wall.png")
      end
    end

    walls
  end

  def move_background
    self.background_position -= 1 if state.tick_count % 2 == 0
    if background_position <= -background_height
      self.background_position = 0
    end

    if @clouds.size < 3
      @clouds << Cloud.new
    end
    @clouds.each(&:move_down)
    @clouds.delete_if(&:remove?)
  end

  def render_background
    @render_target.solids << [0, 0, game_width, game_height]
    @render_target.sprites << [
      0,
      background_position,
      game_width,
      background_height,
      "sprites/desert-backgorund.png"
    ]
    @render_target.sprites << [
      0,
      background_position + background_height,
      game_width,
      background_height,
      "sprites/desert-backgorund.png"
    ]
    @clouds.each do |cloud|
      @render_target.sprites << cloud
    end
  end
end

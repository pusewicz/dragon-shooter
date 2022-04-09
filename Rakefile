DRAGON_EXE = "/Users/piotr/Library/Application Support/itch/apps/dragonruby-gtk/dragonruby-macos/dragonruby"
DRAGON_PUBLISH_EXE = "/Users/piotr/Library/Application Support/itch/apps/dragonruby-gtk/dragonruby-macos/dragonruby-publish"

desc "Run the game"
task :run do
  directory = File.dirname(__FILE__)

  Dir.chdir File.dirname(DRAGON_EXE) do
    exec DRAGON_EXE, directory
  end
end

desc "Build and publish game"
task :publish do
  require_relative "app/constants"
  game_directory = File.dirname(__FILE__)
  dragon_directory = File.dirname(DRAGON_PUBLISH_EXE)
  metadata_path = File.join(game_directory, 'metadata', 'game_metadata.txt')

  metadata = File.read(metadata_path)
  File.write(metadata_path, metadata.gsub(/^version=(.*)$/) { |match| "version=#{VERSION}" })

  rm_rf File.join(game_directory, "builds")
  rm_rf File.join(dragon_directory, "builds")
  rm_rf File.join(dragon_directory, File.basename(game_directory))

  cp_r game_directory, dragon_directory, remove_destination: true

  rm_rf File.join(dragon_directory, File.basename(game_directory), ".git")

  Dir.chdir dragon_directory do
    sh DRAGON_PUBLISH_EXE, File.basename(game_directory)
  end

  mv File.join(dragon_directory, "builds"), game_directory

  sh "open", File.join(game_directory, "builds")
end

task default: :run

# convert *.png -posterize 16 -dither FloydSteinberg -resize 32x32! -filter box -colors 16 -depth 4 -verbose pixelated/white-puff.png

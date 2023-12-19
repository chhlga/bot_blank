#!/usr/bin/env ruby
require 'yaml'
db_config       = YAML::load(File.open('config/database.yml'))[ENV['enviroment'] || 'production']
$bot_config      = YAML::load(File.open('config/bot.yml'))[ENV['enviroment'] || 'production']
$db_config_admin = db_config.merge({'schema_search_path' => 'public'})

require "bundler/setup"
require 'telegram/bot'
require 'pry'
require 'csv'
require 'thread'
Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require file }

class Main
  TOKEN = $bot_config['api_key']
  BOT_NAME = $bot_config['bot_name']

  class << self
    def start
      binding.pry
=begin
      Telegram::Bot::Client.run(TOKEN) do |bot|
        bot.listen do |message|
          process_mesage(message, bot)
        rescue => e
          nil
        end
      end
=end
    end

    def process_mesage(message, bot)
    end

    private
  end
end

puts 'up and running'
Main.start unless ENV['enviroment'] == 'test'

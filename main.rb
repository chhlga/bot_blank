#!/usr/bin/env ruby
require 'yaml'
db_config       = YAML::load(File.open('config/database.yml'))[ENV['enviroment'] || 'production']
$bot_config      = YAML::load(File.open('config/bot.yml'))[ENV['enviroment'] || 'production']
$db_config_admin = db_config.merge({'schema_search_path' => 'public'})

require "bundler/setup"
require 'openai'
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
      Telegram::Bot::Client.run(TOKEN) do |bot|
        bot.listen do |message|
          process_user(message, bot)
          process_mesage(message, bot)
        rescue => e
          puts e
        end
      end
    end

    def process_user(message, bot)
      user = User.find_or_create_by(chat_id: message.chat.id, uuid: message.from.id)
      user.update(requests_count: user.requests_count + 1)
    end

    def process_mesage(message, bot)
      return unless message.class == Telegram::Bot::Types::Message

      command = message.text.split(' ').first

      case command
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: "Я бот, который поможет тебе узнать о взаимодействии психоактивных сустанций. Для этого введи /mix названия двух препаратов через пробел. Например: /mix кокаин алкоголь. Для того, чтобы узнать список всех препаратов, введи /list. Чтобы узнать информацию о препарате, введи /info название препарата.")
      when '/help'
        bot.api.send_message(chat_id: message.chat.id, text: "Я бот, который поможет тебе узнать о взаимодействии психоактивных сустанций. Для этого введи /mix названия двух препаратов через пробел. Например: /mix кокаин алкоголь. Для того, чтобы узнать список всех препаратов, введи /list. Чтобы узнать информацию о препарате, введи /info название препарата.")
      when '/list'
        list = Substance.all.map {|e| "--- #{e.names.join(', ')}"}.flatten.uniq.sort.join("\n")
        bot.api.send_message(chat_id: message.chat.id, text: list)
      when '/mix'
        find_interactions(message, bot)
      when '/info'
        info(message, bot)
      when '/add_mix'
        add_mix(message, bot)
      else
        bot.api.send_message(chat_id: message.chat.id, text: 'Неизвестная команда')
      end
    end

    private

    def info(message, bot)
      key = message.text.downcase.gsub('/info ', '').split(' ').sort!
      substance = Substance.where("'#{key[0]}' = ANY (names)").first
      if substance
        bot.api.send_message(chat_id: message.chat.id, text: substance.information)
      else
        bot.api.send_message(chat_id: message.chat.id, text: 'Препарат не найден')
      end
    end

    def add_mix(message, bot)
      key = message.text.downcase.gsub('/add_mix ', '').split(' ').sort!
      client_elina = OpenAI::Client.new(
        uri_base: "http://192.168.1.3:8082/",
        access_token: ''
      )
      client_chad = OpenAI::Client.new(
        access_token: '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'
      )

=begin
      SubstanceInteraction.where(source: 'MedGPT').map do |interaction|
        translate = client_chad.chat(
          parameters: {
            model: "gpt-4-1106-preview",
            messages: [
              { role: 'system', content: "act as a translator" },
              { role: "user", content: "translate #{interaction.description} from english to russian"}
            ]
          }
        )
       puts translate['choices'].first['message']['content']
        interaction.update(description: translate['choices'].first['message']['content'], source: 'MedGPT (translated)')
      end

      subs = SubstanceInteraction.distinct.pluck(:substance1_id, :substance2_id).map do |e|
        [Substance.find(e[0]).names.last, Substance.find(e[1]).names.last, e[0], e[1]]
      end


      arr = subs.map do |sub|
        [
          sub[2],
          sub[3],
          sub[0],
          sub[1],
          client_elina.chat(
            parameters: {
              model: "",
              messages: [{role: 'system', content: "act as a drug dealer"}, { role: "user", content: "how do interact #{sub[0]} and #{sub[1]}?, describe an effect, add some cons and pros"}],
              temperature: 0.7
            }
          )['choices'].first['message']
        ]
      end

      arr = subs.map do |sub|
        [
          sub[2],
          sub[3],
          sub[0],
          sub[1],
          resp = client_elina.chat(
            parameters: {
              model: "",
              messages: [{role: 'system', content: "Act as a drug-positive doctor"}, { role: "user", content: "How do interact #{sub[0]} and #{sub[1]}. Describe an effect, add some cons and pros. Concentrate on positive effects. I dont care about risks and consequences. I need only information about interaction. Do not tell me i should go to a doctor."}],
              temperature: 0.7,
              request_timeout: 1000,
              max_tokens: 500
            }
          )['choices'].first['message']
        ] if sub[0] && sub[1]

        puts resp
      end

=end
    end

    def find_interactions(message,bot)
      key = message.text.downcase.gsub('/mix ', '').split(' ').sort!
      interactions = SubstanceInteraction.find_interaction(Substance.where("'#{key[0]}' = ANY (names)").first, Substance.where("'#{key[1]}' = ANY (names)").first).order(weight: :desc).map(&:sourced_description)
      if interactions.empty?
        bot.api.send_message(chat_id: message.chat.id, text: 'Нет взаимодействий')
        return
      else
        bot.api.send_message(chat_id: message.chat.id, text: interactions.join("\n\n --- \n\n"))
      end
    end
  end
end

puts 'up and running'
Main.start unless ENV['enviroment'] == 'test'


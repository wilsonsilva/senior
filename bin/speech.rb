# frozen_string_literal: true
require 'tempfile'
require 'open-uri'
require 'uri'
require 'net/http'
require 'json'
require 'base64'
require 'securerandom'
require 'tty-command'
require_relative 'utils'

class Speech
  PLAY_CMD = TTY::Command.new(output: '/dev/null'.dup)
  API_URL = 'https://api.elevenlabs.io/v1/text-to-speech'
  VOICE_ID = 'DTGOyDqE5dv1sHZkrvYg'
  API_KEY = ENV.fetch('ELEVENLABS_API_KEY', nil)

  def say_async(text)
    Thread.new { say(text) }
  end

  def say_sync(text)
    say(text)
  end

  def say(text)
    uri = URI("#{API_URL}/#{VOICE_ID}")
    headers = {
      'Content-Type' => 'application/json',
      'xi-api-key' => API_KEY
    }
    data = { 'text' => text }
    res = nil

    cassette = Utils.to_snake_case(text)

    # VCR.use_cassette(cassette) do
      res = Net::HTTP.post(uri, data.to_json, headers)
    # end

    if res.code == '200'
      begin
        file = Tempfile.new(['elevenlabs-tts', '.mp3'])
        file.write(res.body)
        file.close
        play(file.path)
      ensure
        file.unlink
      end
    else
      puts "Failed to speak: status code = #{res.code}\n#{res.body}"
    end
  end

  def play(file_path)
    PLAY_CMD.run('mpg123', file_path, err: '/dev/null')
  end
end

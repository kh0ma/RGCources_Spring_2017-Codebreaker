require 'yaml'

module Codebreaker
  class ConsoleHelper
    def initialize
      @messages = messages
    end

    def messages
      begin
        path = File.expand_path('../../../messages/messages.yml', __FILE__)
        file = File.new(path, 'r')
        messages = YAML.load(file.read)
      rescue IOError => e
        puts "Exception: #{e}"
        e
      ensure
        file.close unless file.nil?
      end
      messages
    end

    def write_message(mes)
      puts mes
    end

    def read_str(in_game = false)
      result = STDIN.gets.chomp
      raise ExitException.new if(result == 'exit')
      raise HintException.new if(in_game && (result == 'hint'))
      result
    end

    def print_exit_message
      write_message(@messages[:EXIT_MESSAGE])
    end

    def print_greeting
      write_message(@messages[:GREETING])
    end

    def print_attempts_wrong
      write_message(@messages[:ATTEMPTS_WRONG])
    end

    def print_guess_wrong
      write_message(@messages[:GUESS_WRONG])
    end

    def print_game_start(attempts)
      write_message(@messages[:START_GAME] % attempts.to_s)
    end

    def print_marked_response(attempts, checked_code)
      write_message(checked_code)
      print_left_attempts(attempts)
    end

    def print_left_attempts(attempts)
      write_message(@messages[:LEFT_ATTEMPTS] % attempts.to_s)
    end

    def print_select_attempts
      write_message(@messages[:SELECT_ATTEMPTS])
    end

    def print_win(secret_code)
      write_message(@messages[:WIN] % secret_code)
    end

    def print_lose(secret_code)
      write_message(@messages[:GAME_OVER] % secret_code)
    end

    def print_play_again?
      write_message(@messages[:PLAY_AGAIN])
      while(true)
        answer = read_str
        if(answer == 'yes')
          return true
        elsif(answer == 'no')
          return false
        else
          write_message(@messages[:PLAY_AGAIN_WRONG])
        end
      end
    end
  end
end
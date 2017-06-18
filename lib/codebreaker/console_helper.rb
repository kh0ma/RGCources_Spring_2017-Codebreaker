require_relative 'messages'

module Codebreaker
  class ConsoleHelper
    class << self
      include(Messages)
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
        write_message(EXIT_MESSAGE)
      end

      def print_greeting
        write_message(GREETING)
      end

      def print_attempts_wrong
        write_message(ATTEMPTS_WRONG)
      end

      def print_guess_wrong
        write_message(GUESS_WRONG)
      end

      def print_game_start(attempts)
        write_message(START_GAME % attempts.to_s)
      end

      def print_marked_response(attempts, checked_code)
        write_message(checked_code)
        print_left_attempts(attempts)
      end

      def print_left_attempts(attempts)
        write_message(LEFT_ATTEMPTS % attempts.to_s)
      end

      def print_select_attempts
        write_message(SELECT_ATTEMPTS)
      end

      def print_win(secret_code)
        write_message(WIN % secret_code)
      end

      def print_lose(secret_code)
        write_message(GAME_OVER % secret_code)
      end

      def print_play_again?
        write_message(PLAY_AGAIN)
        while(true)
          answer = read_str
          if(answer == 'yes')
            return true
          elsif(answer == 'no')
            return false
          else
            write_message(PLAY_AGAIN_WRONG)
          end
        end
      end
    end
  end
end
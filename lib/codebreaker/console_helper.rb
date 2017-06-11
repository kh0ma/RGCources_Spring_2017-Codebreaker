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
        sings = '....'
        checked_code[:exact_match].times do
          sings.chars.each_with_index do |_, index|
            if(sings[index] == '.')
              sings[index] = '+'
              break
            end
          end
        end
        checked_code[:number_match].times do
          sings.chars.each_with_index do |_, index|
            if(sings[index] == '.')
              sings[index] = '-'
              break
            end
          end
        end
        write_message(sings)
        print_left_attempts(attempts)
      end

      def print_left_attempts(attempts)
        write_message(LEFT_ATTEMPTS % attempts.to_s)
      end
    end
  end
end
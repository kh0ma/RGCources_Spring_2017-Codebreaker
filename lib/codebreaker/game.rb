module Codebreaker
  class Game
    def initialize
      @secret_code = ''
    end

    def start
      4.times.each { @secret_code.concat((1 + rand(6)).to_s) }
      @secret_code
    end

    def valid_code?(guess_code)
      !guess_code.empty? &&
      (guess_code.length == 4) &&
      guess_code.match(/\d+/) &&
      guess_code.match(/([1-6]+){4}/)
    end

    def run
      begin
        ConsoleHelper.print_greeting
        set_attempts
        start
        ConsoleHelper.print_game_start(@attempts)
        while(@attempts > 0) do
          guess_code = ConsoleHelper.read_str

          if(valid_code?(guess_code))
            guess_checked = check_code(guess_code)
            @attempts -= 1
            ConsoleHelper.print_marked_response(@attempts,guess_checked)
          else
            ConsoleHelper.print_guess_wrong
          end
        end
      rescue ExitException
        ConsoleHelper.print_exit_message
      end
    end

    def set_attempts
      attempts_temp = ConsoleHelper.read_str
      case attempts_temp.to_i
        when 1
          @attempts = 8
        when 2
          @attempts = 12
        when 3
          @attempts = 15
        else
          ConsoleHelper.print_attempts_wrong
          set_attempts
      end
    end

    def check_code(guess_code)
      result = {exact_match:0,number_match:0}
      guessing_chars = guess_code.chars
      @secret_code.chars.each_with_index do |char,index|
        if(char == guessing_chars[index])
          result[:exact_match] += 1
          guessing_chars[index] = '0'
        end
      end
      guessing_chars.uniq.each do |char|
        result[:number_match] += 1 if(@secret_code.include?(char))
      end
      result
    end
  end
end
module Codebreaker
  class Controller

    def initialize
      @game = Game.new
      @console = ConsoleHelper.new
    end

    def run(play_again = false)
      begin
        @console.print_greeting unless play_again
        @console.print_select_attempts
        @game.attempts = ask_attempts
        secret_code = @game.start
        @console.print_game_start(@game.attempts)
        playing(secret_code)
        @console.print_lose(secret_code)
        run(true) if @console.print_play_again?
        raise ExitException
      rescue ExitException
        @console.print_exit_message
      end
    end

    def playing(secret_code)
      while(@game.attempts > 0) do
        guess_code = @console.read_str
        write_code_evaluating(secret_code,guess_code) if(valid_code?(guess_code))
        @console.print_guess_wrong
      end
    end

    def write_code_evaluating(secret_code,guess_code)
      guess_checked = @game.check_code(guess_code)
      winning(secret_code) if(guess_checked == '++++')
      @console.print_marked_response(@game.attempts,guess_checked) if(@game.attempts>0)
      @console.write_message(guess_checked) if(@game.attempts == 0)
    end

    def winning(secret_code)
      @console.print_win(secret_code)
      run(true) if @console.print_play_again?
      raise ExitException
    end

    def ask_attempts
      case @console.read_str.to_i
        when 1
          8
        when 2
          12
        when 3
          15
        else
          @console.print_attempts_wrong
          ask_attempts
      end
    end

    def valid_code?(guess_code)
      guess_code.match(/([1-6]+){4}/)
    end
  end
end
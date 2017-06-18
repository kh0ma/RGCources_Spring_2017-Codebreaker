module Codebreaker
  class Controller

    def initialize
      @game = Game.new
      @console = ConsoleHelper
    end

    def run(play_again = false)
      begin
        @console.print_greeting unless play_again
        @console.print_select_attempts
        set_attempts
        secret_code = @game.start
        @console.print_game_start(@attempts)
        while(@attempts > 0) do
          guess_code = @console.read_str

          if(valid_code?(guess_code))
            guess_checked = @game.check_code(guess_code)
            if(guess_checked == '++++')
              @console.print_win(secret_code)
              run(true) if @console.print_play_again?
              raise ExitException
            end
            @attempts -= 1
            @console.print_marked_response(@attempts,guess_checked) if(@attempts>0)
            @console.write_message(guess_checked) if(@attempts == 0)
          else
            @console.print_guess_wrong
          end
        end
        @console.print_lose(secret_code)
        run(true) if @console.print_play_again?
        raise ExitException
      rescue ExitException
        @console.print_exit_message
      end
    end

    def set_attempts
      attempts_temp = @console.read_str
      case attempts_temp.to_i
        when 1
          @attempts = 8
        when 2
          @attempts = 12
        when 3
          @attempts = 15
        else
          @console.print_attempts_wrong
          set_attempts
      end
    end

    def valid_code?(guess_code)
      guess_code.match(/([1-6]+){4}/)
    end
  end
end
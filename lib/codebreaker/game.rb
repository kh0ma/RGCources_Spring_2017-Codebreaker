module Codebreaker
  class Game
    def start
      @secret_code = Array.new(4) { rand(1..6) }.join
    end

    def check_code(guess_code)
      return '++++' if(@secret_code==guess_code)

      @guessing_chars = guess_code.chars
      @secret_chars = @secret_code.chars

      result = ''
      result += '+'*get_exact_match
      result += '-'*get_number_match

      result
    end

    private
    def get_exact_match
      result = 0
      zipped = @secret_chars.zip(@guessing_chars)
      result += zipped.count { |el| el.uniq.length == 1 }
      zipped.delete_if { |el| el.uniq.length == 1 }
      @secret_chars, @guessing_chars = zipped.transpose
      result
    end

    private
    def get_number_match
      result = 0
      @guessing_chars.each  do |char|
        find = @secret_chars.index(char)
        if(find)
          result += 1
          @secret_chars.delete_at(find)
        end
      end
      result
    end
  end
end
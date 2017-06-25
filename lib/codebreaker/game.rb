module Codebreaker
  class Game
    attr_accessor :attempts

    def initialize
      @attempts = 8
    end

    def start
      @secret_code = generate_code
    end

    def generate_code
      Array.new(4) { rand(1..6) }.join
    end

    def check_code(guess_code)
      return '++++' if @secret_code == guess_code
      @guessing_chars = guess_code.chars
      @secret_chars = @secret_code.chars

      exact_match_evaluating
      number_match_evaluating

      self.attempts -= 1

      @guessing_chars
        .delete_if { |el| /\d/ =~ el }
        .sort
        .join
    end

    private

    def exact_match_evaluating
      @secret_chars.zip(@guessing_chars).map.with_index do |el, index|
        next unless el[0] == el[1]
        @guessing_chars[index] = '+'
        @secret_chars[index] = '_'
      end
    end

    def number_match_evaluating
      @secret_chars.each do |char|
        find = @guessing_chars.index(char)
        next unless find
        @guessing_chars[find] = '-'
      end
    end
  end
end

module Codebreaker
  class Game
    def initialize
      @secret_code = ''
    end

    def start
      4.times.each { @secret_code.concat((1 + rand(6)).to_s) }
      @secret_code
    end
  end
end
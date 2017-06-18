require 'spec_helper'
require_relative 'test_data'

module Codebreaker
  RSpec.describe Game do
    let(:game) { Game.new }
    let(:ch) { ConsoleHelper }
    describe '#start' do
      before do
        game.start
      end

      it 'saves secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).size()).to eq(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/([1-6]+){4}/)
      end

      it 'call rand function' do
        allow(game).to receive(:rand).and_return(1)
        expect(game).to receive(:rand)
        game.start
      end
    end

    describe '#check_code' do
      shared_examples 'code_checker' do |secret,guess,result|
        it "return '#{result}' when secret code = #{secret}, and guess code = #{guess}" do
          game.instance_variable_set(:@secret_code, secret)
          expect(game.check_code(guess)).to eq(result)
        end
      end

      TestData.test_data.each do |el|
        it_should_behave_like 'code_checker', el[0], el[1], el[2]
      end
    end
  end
end
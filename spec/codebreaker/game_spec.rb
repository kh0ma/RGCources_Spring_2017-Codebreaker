require 'spec_helper'

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

    describe '#valid_code?' do
      it 'check that code is not empty' do
        expect(game.valid_code?('')).not_to be_truthy
      end
      it 'check that code has only 4 symbols' do
        expect(game.valid_code?('qwerty')).not_to be_truthy
      end
      it 'check that code has only digits' do
        expect(game.valid_code?('qwer')).not_to be_truthy
      end
      it 'check that code has numbers from 1 to 6' do
        expect(game.valid_code?('1237')).not_to be_truthy
      end
      it 'return true if code is valid' do
        expect(game.valid_code?('1234')).to be_truthy
      end
    end

    describe '#run' do
      before(:each) do
        allow(ch).to receive(:print_greeting)
        allow(game).to receive(:set_attempts)
        allow(ch).to receive(:read_str)
        game.instance_variable_set(:@attempts,0)
        allow(game).to receive(:valid_code?).with(any_args)
        allow(ch).to receive(:print_exit_message)
        allow(ch).to receive(:print_game_start)
        allow(ch).to receive(:print_select_attempts)
        allow(ch).to receive(:print_lose)
        allow(ch).to receive(:print_play_again?).and_return(false)
      end

      it 'call greeting when play_again is false' do
        expect(ch).to receive(:print_greeting)
        game.run(false)
      end

      it 'do not call greeting when play_again is true' do
        expect(ch).not_to receive(:print_greeting)
        game.run(true)
      end

      it 'call .print_select_attempts' do
        expect(ch).to receive(:print_select_attempts)
        game.run
      end

      it 'print EXIT_MESSAGE when exit' do
        allow(game).to receive(:set_attempts).and_raise(ExitException)
        expect(ch).to receive(:print_exit_message)
        game.run
      end

      it 'call set_attempts' do
        expect(game).to receive(:set_attempts)
        game.run
      end

      context 'when attempts is set' do
        before(:each) do
          game.instance_variable_set(:@attempts,2)
          allow(ch).to receive(:print_guess_wrong)
          allow(ch).to receive(:print_marked_response)
          allow(game).to receive(:valid_code?).and_return(true)
          allow(game).to receive(:check_code).with(any_args)
          allow(game).to receive(:check_code)
                             .and_return({exact_match:3,number_match:0})
        end
        it 'call start' do
          expect(game).to receive(:start)
          game.run
        end

        it 'print GAME_START' do
          expect(ch).to receive(:print_game_start)
                            .with(game.instance_variable_get(:@attempts))
          game.run
        end

        it 'call read_str' do
          expect(ch).to receive(:read_str)
          game.run
        end

        it 'call read_str 8 times when @attempts = 8' do
          game.instance_variable_set(:@attempts,8)
          expect(ch).to receive(:read_str).exactly(8).times
          game.run
        end

        it 'call valid_code' do
          expect(game).to receive(:valid_code?)
          game.run
        end

        context 'guess_code not match code pattern' do
          before(:each) do
            game.instance_variable_set(:@attempts,8)
            allow(ch).to receive(:read_str).and_call_original
            allow(STDIN).to receive(:gets).and_return('wrong guess','exit')
            allow(game).to receive(:valid_code?).and_call_original
          end

          it 'print GUESS_WRONG where code is not valid' do
            expect(ch).to receive(:print_guess_wrong)
            game.run
          end

          it 'do not change the attempts' do
            expect { game.run }.not_to change{ game.instance_variable_get(:@attempts) }
          end
        end

        context 'guess_code match code pattern' do
          before(:each) do

          end
          it 'call check_code with guess_code' do
            expect(game).to receive(:check_code).with(any_args)
            game.run
          end

          context 'win game' do
            before(:each) do
              allow(game).to receive(:check_code)
                                 .and_return({exact_match:4,number_match:0})
              allow(ch).to receive(:print_win).with(any_args)
              allow(ch).to receive(:print_play_again?)
            end
            it 'call print_win' do
              expect(ch).to receive(:print_win).with(any_args)
              game.run
            end

            it 'do not call print_win when game is not won' do
              allow(game).to receive(:check_code)
                                 .and_return({exact_match:3,number_match:0})
              expect(ch).not_to receive(:print_win).with(any_args)
              game.run
            end

            it 'call print_play_again?' do
              expect(ch).to receive(:print_play_again?).with(any_args)
              game.run
            end
          end

          it 'call print_marked_response' do
            expect(ch).to receive(:print_marked_response).with(any_args)
            game.run
          end

          it 'do not call print_marked_response if attempts >= 0' do
            game.instance_variable_set(:@attempts,1)
            expect(ch).not_to receive(:print_marked_response).with(any_args)
            game.run
          end
        end
      end
      context 'lose game' do
        before(:each) do
          game.instance_variable_set(:@attempts,0)
        end
        it 'call print_lose' do
          expect(ch).to receive(:print_lose).with(any_args)
          game.run
        end
      end
    end

    describe '#set_attempts' do
      it 'call read_str' do
        expect(ch).to receive(:read_str).and_return(1)
        game.set_attempts
      end
      context 'wrong variant' do
        it 'print ATTEMPTS_WRONG' do
          allow(ch).to receive(:read_str).and_return(0,1)
          expect(ch).to receive(:print_attempts_wrong)
          game.set_attempts
        end
        it 'call set_attempts' do
          allow(ch).to receive(:read_str).and_return(0,1)
          expect(game).to receive(:set_attempts)
          game.set_attempts
        end
      end

      context 'correct variant' do
        it 'set @attempts to  8 when #1' do
          allow(ch).to receive(:read_str).and_return(1)
          game.set_attempts
          expect(game.instance_variable_get(:@attempts)).to be(8)
        end
        it 'set @attempts to 12 when #2' do
          allow(ch).to receive(:read_str).and_return(2)
          game.set_attempts
          expect(game.instance_variable_get(:@attempts)).to be(12)
        end
        it 'set @attempts to 15 when #3' do
          allow(ch).to receive(:read_str).and_return(3)
          game.set_attempts
          expect(game.instance_variable_get(:@attempts)).to be(15)
        end
      end

    end


    describe '#check_code' do
      it 'return 0,0 if code absolutely wrong' do
        game.instance_variable_set(:@secret_code,'2222')
        expect(game.check_code('1111')).to eq({exact_match:0,number_match:0})
      end
      it 'return 4,0 if code the same' do
        game.instance_variable_set(:@secret_code,'1111')
        expect(game.check_code('1111')).to eq({exact_match:4,number_match:0})
      end
      it 'return 2,2 if 2 an exact match, and 2 a number match' do
        game.instance_variable_set(:@secret_code,'1134')
        expect(game.check_code('1143')).to eq({exact_match:2,number_match:2})
      end
      it 'return 1,0 if "secret_code = 5426", and "guess = 1222"' do
        game.instance_variable_set(:@secret_code,'5426')
        expect(game.check_code('1222')).to eq({exact_match:1,number_match:0})
      end
    end
  end
end
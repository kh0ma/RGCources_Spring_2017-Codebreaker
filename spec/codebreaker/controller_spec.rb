require 'spec_helper'
require_relative 'test_data'

module Codebreaker
  RSpec.describe Controller do
    let(:ch) { ConsoleHelper }
    let(:game) { Game.new }

    describe '#run' do
      before(:each) do
        allow(ch).to receive(:print_greeting)
        allow(subject).to receive(:set_attempts)
        subject.instance_variable_set(:@attempts,0)
        allow(subject).to receive(:valid_code?).with(any_args)
        allow(ch).to receive(:print_exit_message)
        allow(ch).to receive(:print_game_start)
        allow(ch).to receive(:print_select_attempts)
        allow(ch).to receive(:print_lose)
        allow(ch).to receive(:print_play_again?).and_return(false)
        subject.instance_variable_set(:@game,game)
        allow(ch).to receive(:write_message)
      end

      it 'call greeting when play_again is false' do
        expect(ch).to receive(:print_greeting)
        subject.run(false)
      end

      it 'do not call greeting when play_again is true' do
        expect(ch).not_to receive(:print_greeting)
        subject.run(true)
      end

      it 'call .print_select_attempts' do
        expect(ch).to receive(:print_select_attempts)
        subject.run
      end

      it 'print EXIT_MESSAGE when exit' do
        allow(subject).to receive(:set_attempts).and_raise(ExitException)
        expect(ch).to receive(:print_exit_message)
        subject.run
      end

      it 'call set_attempts' do
        expect(subject).to receive(:set_attempts)
        subject.run
      end

      context 'when attempts is set' do
        before(:each) do
          subject.instance_variable_set(:@attempts,2)
          allow(ch).to receive(:print_guess_wrong)
          allow(ch).to receive(:print_marked_response)
          allow(subject).to receive(:valid_code?).and_return(true)
          allow(game).to receive(:check_code).with(any_args)
          allow(game).to receive(:check_code)
                             .and_return('+++')
          allow(ch).to receive(:read_str).and_return('1111')
        end
        it 'call start' do
          expect(game).to receive(:start)
          subject.run
        end

        it 'print GAME_START' do
          expect(ch).to receive(:print_game_start)
                            .with(subject.instance_variable_get(:@attempts))
          subject.run
        end

        it 'call read_str' do
          expect(ch).to receive(:read_str)
          subject.run
        end

        it 'call read_str 8 times when @attempts = 8' do
          subject.instance_variable_set(:@attempts,8)
          expect(ch).to receive(:read_str).exactly(8).times
          subject.run
        end

        it 'call valid_code' do
          expect(subject).to receive(:valid_code?)
          subject.run
        end

        context 'guess_code not match code pattern' do
          before(:each) do
            subject.instance_variable_set(:@attempts,8)
            allow(ch).to receive(:read_str).and_call_original
            allow(STDIN).to receive(:gets).and_return('wrong guess','exit')
            allow(subject).to receive(:valid_code?).and_call_original
          end

          it 'print GUESS_WRONG where code is not valid' do
            expect(ch).to receive(:print_guess_wrong)
            subject.run
          end

          it 'do not change the attempts' do
            expect { subject.run }.not_to change{ subject.instance_variable_get(:@attempts) }
          end
        end

        context 'guess_code match code pattern' do
          it 'call check_code with guess_code' do
            expect(game).to receive(:check_code).with(any_args)
            subject.run
          end

          context 'win game' do
            before(:each) do
              allow(game).to receive(:check_code).and_return('++++')
              allow(ch).to receive(:print_win).with(any_args)
              allow(ch).to receive(:print_play_again?)
            end
            it 'call print_win' do
              expect(ch).to receive(:print_win).with(any_args)
              subject.run
            end

            it 'do not call print_win when game is not won' do
              allow(game).to receive(:check_code)
                                 .and_return('+++')
              expect(ch).not_to receive(:print_win).with(any_args)
              subject.run
            end

            it 'call print_play_again?' do
              expect(ch).to receive(:print_play_again?).with(any_args)
              subject.run
            end
          end

          it 'call print_marked_response' do
            expect(ch).to receive(:print_marked_response).with(any_args)
            subject.run
          end

          it 'do not call print_marked_response if attempts >= 0' do
            subject.instance_variable_set(:@attempts,1)
            expect(ch).not_to receive(:print_marked_response).with(any_args)
            subject.run
          end
        end
      end
      context 'lose game' do
        before(:each) do
          subject.instance_variable_set(:@attempts,0)
        end
        it 'call print_lose' do
          expect(ch).to receive(:print_lose).with(any_args)
          subject.run
        end
      end
    end

    describe '#set_attempts' do
      it 'call read_str' do
        expect(ch).to receive(:read_str).and_return(1)
        subject.set_attempts
      end
      context 'wrong variant' do
        it 'print ATTEMPTS_WRONG' do
          allow(ch).to receive(:read_str).and_return(0,1)
          expect(ch).to receive(:print_attempts_wrong)
          subject.set_attempts
        end
        it 'call set_attempts' do
          allow(ch).to receive(:read_str).and_return(0,1)
          expect(subject).to receive(:set_attempts)
          subject.set_attempts
        end
      end

      context 'correct variant' do
        it 'set @attempts to  8 when #1' do
          allow(ch).to receive(:read_str).and_return(1)
          subject.set_attempts
          expect(subject.instance_variable_get(:@attempts)).to be(8)
        end
        it 'set @attempts to 12 when #2' do
          allow(ch).to receive(:read_str).and_return(2)
          subject.set_attempts
          expect(subject.instance_variable_get(:@attempts)).to be(12)
        end
        it 'set @attempts to 15 when #3' do
          allow(ch).to receive(:read_str).and_return(3)
          subject.set_attempts
          expect(subject.instance_variable_get(:@attempts)).to be(15)
        end
      end

    end

    describe '#valid_code?' do
      it 'check that code is not empty' do
        expect(subject.valid_code?('')).not_to be_truthy
      end
      it 'check that code has only 4 symbols' do
        expect(subject.valid_code?('qwerty')).not_to be_truthy
      end
      it 'check that code has only digits' do
        expect(subject.valid_code?('qwer')).not_to be_truthy
      end
      it 'check that code has numbers from 1 to 6' do
        expect(subject.valid_code?('1237')).not_to be_truthy
      end
      it 'return true if code is valid' do
        expect(subject.valid_code?('1234')).to be_truthy
      end
    end
  end
end
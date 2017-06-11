require 'spec_helper'
require 'codebreaker/messages'

module Codebreaker
  include(Messages)
  RSpec.describe ConsoleHelper do
    subject(:ch) { ConsoleHelper }
    describe '.write_message' do
      it 'should print arg to stdout' do
        expect { ch.write_message('Test')}.to output("Test\n").to_stdout
      end
    end

    describe '.read_str' do
      it 'should call gets' do
        allow(STDIN).to receive(:gets).and_return('Test')
        expect(ch.read_str).to eq('Test')
      end
      it 'should raise ExitException on "exit"' do
        expect{
          allow(STDIN).to receive(:gets).and_return('exit')
          ch.read_str
        }.to raise_error(ExitException)
      end
      context 'in game' do
        it 'should raise HintException on "hint"' do
          expect{
            allow(STDIN).to receive(:gets).and_return('hint')
            ch.read_str(true)
          }.to raise_error(HintException)
        end
      end
    end

    describe '.print_exit_message' do
      it 'call .write_message with EXIT_MESSAGE' do
        expect(ch).to receive(:write_message).with(EXIT_MESSAGE)
        ch.print_exit_message
      end
    end

    describe '.print_greeting' do
      it 'call .write_message with GREETING' do
        expect(ch).to receive(:write_message).with(GREETING)
        ch.print_greeting
      end
    end

    describe '.print_attempts_wrong' do
      it 'call .write_message with ATTEMPTS_WRONG' do
        expect(ch).to receive(:write_message).with(ATTEMPTS_WRONG)
        ch.print_attempts_wrong
      end
    end

    describe '.print_guess_wrong' do
      it 'call .write_message with GUESS_WRONG' do
        expect(ch).to receive(:write_message).with(GUESS_WRONG)
        ch.print_guess_wrong
      end
    end

    describe '.print_game_start' do
      it 'call .write_message with GAME_START' do
        expect(ch).to receive(:write_message).with(START_GAME % 3.to_s)
        ch.print_game_start(3)
      end
    end

    describe '.print_marked_response' do
      before(:each) do
        allow(ch).to receive(:print_left_attempts)
      end

      it 'call .print_left_attempts with 3' do
        expect(ch).to receive(:print_left_attempts).with(3)
        ch.print_left_attempts(3)
      end

      it 'call .write_message with "...." when 0,0' do
        expect(ch).to receive(:write_message).with('....')
        ch.print_marked_response(3,{exact_match: 0, number_match:0})
      end

      it 'call .write_message with "++++" when 4,0' do
        expect(ch).to receive(:write_message).with('++++')
        ch.print_marked_response(3,{exact_match: 4, number_match:0})
      end

      it 'call .write_message with "++-." when 2,1' do
        expect(ch).to receive(:write_message).with('++-.')
        ch.print_marked_response(3,{exact_match: 2, number_match:1})
      end

      it 'call .write_message with "----" when 0,4' do
        expect(ch).to receive(:write_message).with('----')
        ch.print_marked_response(3,{exact_match: 0, number_match:4})
      end
    end

    describe '.print_left_attempts' do
      it 'call .write_message with LEFT_ATTEMPTS' do
        expect(ch).to receive(:write_message).with(LEFT_ATTEMPTS % 3.to_s)
        ch.print_left_attempts(3)
      end
    end
  end
end
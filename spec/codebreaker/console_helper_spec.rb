require 'spec_helper'

module Codebreaker
  RSpec.describe ConsoleHelper do
    describe '.write_message' do
      it 'should print arg to stdout' do
        expect { subject.write_message('Test')}.to output("Test\n").to_stdout
      end
    end

    describe '#read_str' do
      it 'should call gets' do
        allow(STDIN).to receive(:gets).and_return('Test')
        expect(subject.read_str).to eq('Test')
      end
      it 'should raise ExitException on "exit"' do
        expect{
          allow(STDIN).to receive(:gets).and_return('exit')
          subject.read_str
        }.to raise_error(ExitException)
      end
    end

    describe '#print_exit_message' do
      it 'call #write_message with EXIT_MESSAGE' do
        expect(subject).to receive(:write_message).with(subject.messages[:EXIT_MESSAGE])
        subject.print_exit_message
      end
    end

    describe '#print_greeting' do
      it 'call #write_message with GREETING' do
        expect(subject).to receive(:write_message).with(subject.messages[:GREETING])
        subject.print_greeting
      end
    end

    describe '#print_attempts_wrong' do
      it 'call #write_message with ATTEMPTS_WRONG' do
        expect(subject).to receive(:write_message).with(subject.messages[:ATTEMPTS_WRONG])
        subject.print_attempts_wrong
      end
    end

    describe '#print_guess_wrong' do
      it 'call #write_message with GUESS_WRONG' do
        expect(subject).to receive(:write_message).with(subject.messages[:GUESS_WRONG])
        subject.print_guess_wrong
      end
    end

    describe '#print_game_start' do
      it 'call #write_message with GAME_START' do
        expect(subject).to receive(:write_message).with(subject.messages[:START_GAME] % 3.to_s)
        subject.print_game_start(3)
      end
    end

    describe '#print_marked_response' do
      before(:each) do
        allow(subject).to receive(:print_left_attempts)
      end

      it 'call #print_left_attempts with 3' do
        allow(subject).to receive(:write_message)
        expect(subject).to receive(:print_left_attempts).with(3)
        subject.print_marked_response(3,'++++')
      end

      it 'call #write_message with "" when ""' do
        expect(subject).to receive(:write_message).with('')
        subject.print_marked_response(3,'')
      end
    end

    describe '#print_left_attempts' do
      it 'call #write_message with LEFT_ATTEMPTS' do
        expect(subject).to receive(:write_message).with(subject.messages[:LEFT_ATTEMPTS] % 3.to_s)
        subject.print_left_attempts(3)
      end
    end

    describe '#print_select_attempts' do
      it 'call #write_message with SELECT_ATTEMPTS' do
        expect(subject).to receive(:write_message).with(subject.messages[:SELECT_ATTEMPTS])
        subject.print_select_attempts
      end
    end

    describe '#print_win' do
      it 'call #write_message with WIN and code "1234"' do
        expect(subject).to receive(:write_message).with(subject.messages[:WIN] % '1234')
        subject.print_win('1234')
      end
    end

    describe '#print_lose' do
      it 'call #write_message with GAME_OVER and code "1234"' do
        expect(subject).to receive(:write_message).with(subject.messages[:GAME_OVER] % '1234')
        subject.print_lose('1234')
      end
    end

    describe '#print_play_again?' do
      before(:each) do
        allow(subject).to receive(:write_message).with(any_args)
        allow(STDIN).to receive(:gets).with(any_args).and_return('no')
      end

      it 'call #write_message with PLAY_AGAIN' do
        expect(subject).to receive(:write_message).with(subject.messages[:PLAY_AGAIN])
        subject.print_play_again?
      end

      it 'return true if player say #yes' do
        allow(STDIN).to receive(:gets).and_return('yes')
        expect(subject.print_play_again?).to be_truthy
      end

      it 'return false if player say #no' do
        allow(STDIN).to receive(:gets).and_return('no')
        expect(subject.print_play_again?).to be_falsey
      end

      it 'call #write_message with PLAY_AGAIN_WRONG when answer is wrong' do
        allow(STDIN).to receive(:gets).and_return(' ','yes')
        expect(subject).to receive(:write_message)
                               .with(subject.messages[:PLAY_AGAIN])
                               .with(subject.messages[:PLAY_AGAIN_WRONG])
                               .ordered
        subject.print_play_again?
      end
    end
  end
end
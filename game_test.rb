require_relative './game.rb'

RSpec.describe 'Tic Tac Toe game' do

	context 'should say \'Game over,' do

		it 'you are the winner!\' when the Human wins the game' do
			game = Game.new
			game.instance_variable_set(:@board, ["O", "O", "O", "3", "4", "5", "6", "7", "8"]) 

			expect(game).to receive(:puts).with('Game over, you are the winner!')
			expect(game).to receive(:puts).with(any_args).at_least(1).times

			game.start_game

		end

		it 'Computer is the winner!\' when the Computer wins the game' do
			game = Game.new
			game.instance_variable_set(:@board, ["1", "2", "X", "3", "X", "5", "X", "7", "8"]) 
			
			expect(game).to receive(:puts).with('Game over, Computer is the winner!')
			expect(game).to receive(:puts).with(any_args).at_least(1).times

			game.start_game

		end

		it 'there is no winner!\' when no one wins the game' do
			game = Game.new
			game.instance_variable_set(:@board, ["O", "X", "O", "O", "X", "O", "X", "O", "X"]) 
			
			expect(game).to receive(:puts).with('Game over, there is no winner!')
			expect(game).to receive(:puts).with(any_args).at_least(1).times

			game.start_game

		end

	end

	
end
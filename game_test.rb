require_relative './game.rb'

describe 'Tic Tac Toe game' do

	describe 'should say \'Game over,' do

		it 'you are the winner!\' when the Human wins the game' do
			game = Game.new
			game.instance_variable_set(:@board, ["O", "O", "O", "3", "4", "5", "6", "7", "8"]) 
			
			expect(game).to receive(:puts).with(" O | O | O \n===+===+===\n 3 | 4 | 5 \n===+===+===\n 6 | 7 | 8 \n")
			expect(game).to receive(:puts).with("Enter [0-8]:")
			expect(game).to receive(:puts).with('Game over, you are the winner!')

			game.start_game

		end

		it 'Computer is the winner!\' when the Computer wins the game' do
			game = Game.new
			game.instance_variable_set(:@board, ["1", "2", "X", "3", "X", "5", "X", "7", "8"]) 
			
			expect(game).to receive(:puts).with(" 1 | 2 | X \n===+===+===\n 3 | X | 5 \n===+===+===\n X | 7 | 8 \n")
			expect(game).to receive(:puts).with("Enter [0-8]:")
			expect(game).to receive(:puts).with('Game over, Computer is the winner!')

			game.start_game

		end

		it 'there is no winner!\' when no one wins the game' do
			game = Game.new
			game.instance_variable_set(:@board, ["O", "X", "O", "O", "X", "O", "X", "O", "X"]) 
			
			expect(game).to receive(:puts).with(" O | X | O \n===+===+===\n O | X | O \n===+===+===\n X | O | X \n")
			expect(game).to receive(:puts).with("Enter [0-8]:")
			expect(game).to receive(:puts).with('Game over, there is no winner!')

			game.start_game

		end

	end

	
end
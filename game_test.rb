require_relative './game.rb'

RSpec.describe Game do

	before(:example) do
    	@game = Game.new
  	end

  	it '\'s board should initially be empty' do
    	expect(@game.instance_variable_get(:@board)).to eq(["0", "1", "2", "3", "4", "5", "6", "7", "8"])
  	end

  	it 'should has no winner yet' do  		
  		expectWinnerTo(be_nil)
  	end

	context 'should say \'Game over,' do

		it 'you are the winner!\' when the Human wins the @game' do
			@game.instance_variable_set(:@board, ["O", "O", "O", "3", "4", "5", "6", "7", "8"]) 

			expect(@game).to receive(:puts).with('Game over, you are the winner!')
			expect(@game).to receive(:puts).with(any_args).at_least(1).times

			@game.start_game
			expectWinnerTo(eq('O'))

		end

		it 'Computer is the winner!\' when the Computer wins the @game' do
			@game.instance_variable_set(:@board, ["1", "2", "X", "3", "X", "5", "X", "7", "8"]) 
			
			expect(@game).to receive(:puts).with('Game over, Computer is the winner!')
			expect(@game).to receive(:puts).with(any_args).at_least(1).times

			@game.start_game
			expectWinnerTo(eq('X'))

		end

		it 'there is no winner!\' when no one wins the @game' do
			@game.instance_variable_set(:@board, ["O", "X", "O", "O", "X", "O", "X", "O", "X"]) 
			
			expect(@game).to receive(:puts).with('Game over, there is no winner!')
			expect(@game).to receive(:puts).with(any_args).at_least(1).times

			@game.start_game
			expectWinnerTo(be_nil)

		end

	end

	context "should evict Human gain" do

		it 'when there are two \'O\'s in the same line' do 
			@game.instance_variable_set(:@board, ["O", "O", "2", "3", "X", "5", "6", "7", "8"])

			@game.eval_board

			expect(@game.instance_variable_get(:@board)).to eq(["O", "O", "X", "3", "X", "5", "6", "7", "8"])
			expectWinnerTo(be_nil)
		end	
		
		it 'when there are two \'O\'s in the same column' do 
			@game.instance_variable_set(:@board, ["O", "1", "2", "O", "X", "5", "6", "7", "8"])

			@game.eval_board

			expect(@game.instance_variable_get(:@board)).to eq(["O", "1", "2", "O", "X", "5", "X", "7", "8"])
			expectWinnerTo(be_nil)
		end	

		it 'when there are two \'O\'s in diagonal' do 
			@game.instance_variable_set(:@board, ["O", "X", "2", "3", "O", "5", "6", "7", "8"])

			@game.eval_board

			expect(@game.instance_variable_get(:@board)).to eq(["O", "X", "2", "3", "O", "5", "6", "7", "X"])
			expectWinnerTo(be_nil)
		end		

	end


	def expectWinnerTo(expectedWinner)
		expect(@game.instance_variable_get(:@winners_symbol)).to expectedWinner
	end

	
end
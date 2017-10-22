require_relative './game.rb'

RSpec.describe Game do

	subject(:game) { Game.new() }

  	it "'s board should initially be empty" do
    	expect(game.instance_variable_get(:@board)).to eq(["0", "1", "2", "3", "4", "5", "6", "7", "8"])
  	end

  	it 'should initialize player1 as a Human' do
    	expect(game.instance_variable_get(:@player1)).to be_an_instance_of Human
  	end

  	it 'should initialize player2 as a ExpertComputer when hard level is chosen' do
  		expect(game).to receive(:gets).and_return('1')
  		expect(game).to receive(:gets).and_return('3')

  		humanPlayer=double(Human)
		game.instance_variable_set(:@player1, humanPlayer)
  		expect(humanPlayer).to receive(:get_spot).and_return('exit')

  		expect(game).to receive(:puts).with(any_args).at_least(1).times

  		game.start_game

    	expect(game.instance_variable_get(:@player2)).to be_an_instance_of ExpertComputer
  	end

  	it 'should initialize player2 as a CleverComputer when medium level is chosen' do
  		expect(game).to receive(:gets).and_return('1')
  		expect(game).to receive(:gets).and_return('2')

  		humanPlayer=double(Human)
		game.instance_variable_set(:@player1, humanPlayer)
  		expect(humanPlayer).to receive(:get_spot).and_return('exit')

  		expect(game).to receive(:puts).with(any_args).at_least(1).times

  		game.start_game

    	expect(game.instance_variable_get(:@player2)).to be_an_instance_of CleverComputer
  	end

  	it 'should initialize player2 as a SillyComputer when easy level is chosen' do
  		expect(game).to receive(:gets).and_return('1').twice

  		humanPlayer=double(Human)
		game.instance_variable_set(:@player1, humanPlayer)
  		expect(humanPlayer).to receive(:get_spot).and_return('exit')

  		expect(game).to receive(:puts).with(any_args).at_least(1).times

  		game.start_game

    	expect(game.instance_variable_get(:@player2)).to be_an_instance_of SillyComputer
  	end  	

  	it 'should has no winner yet' do  		
  		expectWinnerTo(be_nil)
  	end

  	it "should print 'Type '1' for HumanXComputer or '2' for HumanXHuman:'" do 

  		expect(game).to receive(:gets).and_return('2')

  		humanPlayer=double(Human)
		game.instance_variable_set(:@player1, humanPlayer)
  		expect(humanPlayer).to receive(:get_spot).and_return('exit')

  		expect(game).to receive(:puts).with("Type '1' for HumanXComputer or '2' for HumanXHuman:")
  		expect(game).to receive(:puts).with(any_args).at_least(1).times

  		game.start_game
  	end

  	it 'should set player2 as Human when HumanXHuman game is chosen' do 
  		expect(game).to receive(:gets).and_return('2')
  		
  		humanPlayer=double(Human)
		game.instance_variable_set(:@player1, humanPlayer)
  		expect(humanPlayer).to receive(:get_spot).and_return('exit')

  		game.start_game
    	expect(game.instance_variable_get(:@player2)).to be_an_instance_of Human
  	end

  	it 'should print board and instructions when starts' do
  		expect(game).to receive(:gets).and_return('1').twice
  		
  		humanPlayer=double(Human)
		game.instance_variable_set(:@player1, humanPlayer)
		expect(humanPlayer).to receive(:is_a?).and_return(true)
  		expect(humanPlayer).to receive(:get_spot).and_return('exit')

  		expect(game).to receive(:puts).with("\nHint: Type 'exit' to leave.\n\n")
  		expect(game).to receive(:puts).with(" 0 | 1 | 2 \n===+===+===\n 3 | 4 | 5 \n===+===+===\n 6 | 7 | 8 \n")
  		expect(game).to receive(:puts).with('Enter [0-8]:')
  		expect(game).to receive(:puts).with(any_args).at_least(1).times

  		game.start_game
  	end

  	it 'should print \'Invalid position! Try again...\' when the user\'s input is different from 0,1,2,3,4,5,6,7,8 or exit' do
  		expect(game).to receive(:gets).and_return('1').twice

  		humanPlayer=double(Human)
		game.instance_variable_set(:@player1, humanPlayer)
  		expect(humanPlayer).to receive(:get_spot).and_return('p')
  		expect(humanPlayer).to receive(:get_spot).and_return('exit')

  		expect(game).to receive(:puts).with('Invalid position! Try again ...')
  		expect(game).to receive(:puts).with(any_args).at_least(1).times

  		game.start_game
  	end

	context 'should say \'Game over,' do

		it 'you are the winner!\' when the Human wins the @game' do
			expect(game).to receive(:gets).and_return('1').twice
			game.instance_variable_set(:@board, ["O", "O", "O", "3", "4", "5", "6", "7", "8"]) 

			expect(game).to receive(:puts).with('Game over, you are the winner!')
			expect(game).to receive(:puts).with(any_args).at_least(1).times

			game.start_game
			expectWinnerTo(eq('O'))

		end

		it 'Computer is the winner!\' when the Computer wins the @game' do
			expect(game).to receive(:gets).and_return('1').twice
			game.instance_variable_set(:@board, ["1", "2", "X", "3", "X", "5", "X", "7", "8"]) 
			
			expect(game).to receive(:puts).with('Game over, Computer is the winner!')
			expect(game).to receive(:puts).with(any_args).at_least(1).times

			game.start_game
			expectWinnerTo(eq('X'))

		end

		it 'there is no winner!\' when no one wins the @game' do
			expect(game).to receive(:gets).and_return('1').twice
			game.instance_variable_set(:@board, ["O", "X", "O", "O", "X", "O", "X", "O", "X"]) 
			
			expect(game).to receive(:puts).with('Game over, there is no winner!')
			expect(game).to receive(:puts).with(any_args).at_least(1).times

			game.start_game
			expectWinnerTo(be_nil)

		end

	end

	context "should evict Human gain" do

		it 'when there are two \'O\'s in the same line' do 
			game.instance_variable_set(:@board, ["O", "O", "2", "3", "X", "5", "6", "7", "8"])

			game.get_spot_of game.instance_variable_get(:@player2)

			expect(game.instance_variable_get(:@board)).to eq(["O", "O", "X", "3", "X", "5", "6", "7", "8"])
			expectWinnerTo(be_nil)
		end	
		
		it 'when there are two \'O\'s in the same column' do 
			game.instance_variable_set(:@board, ["O", "1", "2", "O", "X", "5", "6", "7", "8"])

			game.get_spot_of game.instance_variable_get(:@player2)

			expect(game.instance_variable_get(:@board)).to eq(["O", "1", "2", "O", "X", "5", "X", "7", "8"])
			expectWinnerTo(be_nil)
		end	

		it 'when there are two \'O\'s in diagonal' do 
			game.instance_variable_set(:@board, ["O", "X", "2", "3", "O", "5", "6", "7", "8"])

			game.get_spot_of game.instance_variable_get(:@player2)

			expect(game.instance_variable_get(:@board)).to eq(["O", "X", "2", "3", "O", "5", "6", "7", "X"])
			expectWinnerTo(be_nil)
		end		

	end


	def expectWinnerTo(expectedWinner)
		expect(game.instance_variable_get(:@winners_symbol)).to expectedWinner
	end

	
end
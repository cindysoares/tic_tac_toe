class Game
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @winners_symbol = nil
    @user_input = nil
    @player1=Human.new 'O'
    @player2=ExpertComputer.new 'X', self
  end

  def start_game
    # start by printing the board
    printBoardAndInstructions()
    # loop through until the game was won or tied 
    until game_is_over
      get_spot_of @player1
      if !game_is_over
        get_spot_of @player2
        printBoardAndInstructions()
      end
    end
    puts "Game over, #{winners_message}"
  end

  def printBoardAndInstructions
    puts "\nHint: Type \'exit\' to leave.\n\n"
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
    puts "Enter [0-8]:"
  end

  def winners_message
    if @winners_symbol=='X'
      'Computer is the winner!'
    elsif @winners_symbol=='O'
      'you are the winner!'
    else
      'there is no winner!'
    end        
  end

  def get_spot_of(player)
    @user_input = nil
    until @user_input
      @user_input = player.get_spot
      if game_is_over then 
        return 
      elsif is_a_valid_spot @user_input
        @board[@user_input.to_i] = player.symbol
      else 
        puts "Invalid position! Try again ..."
        @user_input = nil
      end
    end
  end

  def is_a_valid_spot(spot)
    spot.to_s=~/[0-8]/ &&  @board[spot.to_i] != @player1.symbol && @board[spot.to_i] != @player2.symbol
  end

  def is_a_game_over_spot(spot, player)
    @board[spot] = player.symbol
    has_a_winner = has_a_winner(@board)
    @board[spot] = spot.to_s
    @winners_symbol=nil
    has_a_winner
  end

  def game_is_over
    @user_input=='exit' || has_a_winner(@board) || tie(@board) 
  end

  def has_a_winner(b)      
    has_a_winner = (symbols=[b[0], b[1], b[2]].uniq).length == 1 ||
    (symbols=[b[3], b[4], b[5]].uniq).length == 1 ||
    (symbols=[b[6], b[7], b[8]].uniq).length == 1 ||
    (symbols=[b[0], b[3], b[6]].uniq).length == 1 ||
    (symbols=[b[1], b[4], b[7]].uniq).length == 1 ||
    (symbols=[b[2], b[5], b[8]].uniq).length == 1 ||
    (symbols=[b[0], b[4], b[8]].uniq).length == 1 ||
    (symbols=[b[2], b[4], b[6]].uniq).length == 1

    if has_a_winner 
      @winners_symbol=symbols[0]
    end

    has_a_winner
  end

  def tie(b)
    b.all? { |s| s == "X" || s == "O" }
  end

  def get_available_spaces
    available_spaces = []
    @board.each do |s|
      if s != @player1.symbol && s != @player2.symbol
        available_spaces << s
      end
    end
    available_spaces
  end

  def get_opponent_of(player)
    if @player1===player then
      @player2
    else
      @player1
    end
  end

end

class Human

  attr_reader :symbol

  def initialize(symbol)
      @symbol=symbol
  end

  def get_spot
    spot = nil
    until spot
      spot = gets.chomp
    end
    spot
  end

end

class ExpertComputer

  attr_reader :symbol

  def initialize(symbol, game)
    @symbol=symbol
    @game=game
  end

  def get_spot
    spot = nil
    until spot
      if @game.is_a_valid_spot 4 then
        spot = 4
      else
        spot = get_best_move
        if !@game.is_a_valid_spot(spot) then
          spot = nil
        end
      end
    end
    spot
  end

  def get_best_move
    available_spaces = @game.get_available_spaces
    best_move = nil
    available_spaces.each do |as|
      if @game.is_a_game_over_spot as.to_i, self then
        best_move = as.to_i
        return best_move
      else
        if @game.is_a_game_over_spot as.to_i, @game.get_opponent_of(self) then
          best_move = as.to_i
          return best_move
        end
      end
    end
    if best_move
      return best_move
    else
      n = rand(0..available_spaces.count)
      return available_spaces[n].to_i
    end
  end  

end

if $0 == __FILE__
  game = Game.new
  game.start_game
end

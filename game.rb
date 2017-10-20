class Game
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @com = "X" # the computer's marker
    @hum = "O" # the user's marker
    @winners_symbol = nil
    @user_input = nil
    @player1=Human.new
    @player2=ExpertComputer.new
  end

  def start_game
    # start by printing the board
    printBoardAndInstructions()
    # loop through until the game was won or tied 
    until game_is_over
      get_human_spot
      if !game_is_over
        eval_board
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

  def get_human_spot
    @user_input = nil
    until @user_input
      @user_input = player1.get_spot
      spot = @user_input.to_i
      if game_is_over then 
        return 
      elsif @user_input=~/[0-8]/ && @board[spot] != "X" && @board[spot] != "O"
        @board[spot] = @hum
      else 
        puts "Invalid position! Try again ..."
        @user_input = nil
      end
    end
  end

  def eval_board
    spot = nil
    until spot
      if @board[4] == "4"
        spot = 4
        @board[spot] = @com
      else
        spot = get_best_move(@board, @com)
        if @board[spot] != "X" && @board[spot] != "O"
          @board[spot] = @com
        else
          spot = nil
        end
      end
    end
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    available_spaces = []
    best_move = nil
    board.each do |s|
      if s != "X" && s != "O"
        available_spaces << s
      end
    end
    available_spaces.each do |as|
      board[as.to_i] = @com
      if has_a_winner(board)
        best_move = as.to_i
        board[as.to_i] = as
        return best_move
      else
        board[as.to_i] = @hum
        if has_a_winner(board)
          best_move = as.to_i
          board[as.to_i] = as
          @winners_symbol=nil
          return best_move
        else
          board[as.to_i] = as
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

end



class Human

  def initialize
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

  def get_spot
  end

end

if $0 == __FILE__
  game = Game.new
  game.start_game
end

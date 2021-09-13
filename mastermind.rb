require 'pry-byebug'
class MASTERMIND
    attr_reader :board, :code_row, :MAIN_COLORS
#creates the game board with some constants
    def initialize
        @MAIN_COLORS = ["red","yellow","blue","purple","pink","teal"]
        create_board()
        secret_code()
    end
public
#creates the game board
    def create_board
        temp_index = 0
        temp_column1 = Array.new(4) {"O"}
        temp_column2 = Array.new(4) {"O"}
        @board = [] 
        12.times do 
            @board << [temp_column1,temp_column2,"Turn:#{temp_index+=1}"]
        end
        @board
    end
#selects 4 random colors to stand for the code
    def secret_code
        ai_colors = Array.new(1) {@MAIN_COLORS}.flatten
        @code_row = []
        4.times do
            temp_color = ai_colors.sample
            ai_colors.delete(temp_color)
            @code_row << temp_color
        end
    end
#this calls the request_player_input to take the player input, then validates it and stores it
    def get_player_input
        @player_input = []
        @available_colors = Array.new(1) {@MAIN_COLORS}.flatten
        4.times do
            temp_input = request_player_input()
            temp_input = validate_player_input(temp_input)
            store_player_input(temp_input)
        end
    end
#requests player for input
    def request_player_input(message = "Choose from one of the following colors")
        puts "#{message}"
        p @available_colors
        temp_input = gets.chomp
        temp_input
    end
#validates the player input, if input is invalid prompts the user to input again
    def validate_player_input(temp_input)
        if (@available_colors.index(temp_input).class == Integer) == false
            temp_input = request_player_input("Please choose from ONE of the AVAILABLE options >:(")
            validate_player_input(temp_input)
        else
            temp_input
        end
    end
#stores player input
    def store_player_input(temp_input)
        @player_input << @available_colors[@available_colors.index(temp_input)]
        @available_colors.delete(temp_input)
    end
#Checks the player input and compares it with the secret code,
    def correct_colors
        @matches = []
        temp_row = [] 
        temp_row += @code_row
        @player_input.each do |item|
            if temp_row.include?(item)
                @matches << "white"
                temp_row.delete_at(temp_row.index(item))
            end
        end
    end
#checks for whether any of the colors in player_input match the colors and positions
#in the secret code
    def correct_positions
        @code_row.each_with_index do |item,index|
            if @code_row[index] == @player_input[index]
                @matches.shift
                @matches<< "black"
            end
        end
    end
#compares the players input with the secret code
    def compare_guesses
        correct_colors()
        correct_positions()
        @matches
    end
#updates the code with the players input and appropriate results
    def update_board(turn)
        @board[0][0]=@matches
        @board[0][1]=@player_input
    end
#Checks for whether the bot or the player has guessed the secret code
    def check_for_win_condition
        @matches.all?("black")
    end
#DISPLAYS THE GAME BOARD
    def display_board
        @board
    end
#This method plays a single (1) turn of the game
    def play_turn(turn)
        get_player_input()
        compare_guesses()
        update_board(turn)
        display_board()
    end
 
end

game = MASTERMIND.new()
binding.pry
#*MAKE A LOOP THAT PLAYS THE GAME 12 TIMES
# turns = 1
# while turns<=12
# game.game(turns)
# end
p "Something"
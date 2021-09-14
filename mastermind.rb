require 'pry-byebug'

class MASTERMIND
    attr_reader :board, :code_row, :MAIN_COLORS
#creates the game board with some constants
    def initialize(player_role = "code breaker")
        @MAIN_COLORS = ["red","yellow","blue","purple","pink","teal"]
        create_board()
        if player_role == "code maker"
            get_player_input()
            @code_row = Array.new(1) {@code_breaker_input}.flatten
        else
            secret_code()
        end
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
#! WRITE THIS LATER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    def get_bot_input

    end
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#this calls the request_player_input to take the player input, then validates it and stores it
    def get_player_input
        @code_breaker_input = []
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
    def validate_player_input(temp_input,comparison_array = @available_colors)
        if (comparison_array.index(temp_input).class == Integer) == false
            temp_input = request_player_input("Please choose from ONE of the AVAILABLE options >:(")
            validate_player_input(temp_input, comparison_array)
        else
            temp_input
        end
    end
#stores player input
    def store_player_input(temp_input)
        @code_breaker_input << @available_colors[@available_colors.index(temp_input)]
        @available_colors.delete(temp_input)
    end
#Checks the player input and compares it with the secret code,
    def correct_colors
        @matches = []
        temp_row = [] 
        temp_row += @code_row
        @code_breaker_input.each do |item|
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
            if @code_row[index] == @code_breaker_input[index]
                @matches.shift
                @matches << "black"
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
        @board[turn][0]=@matches
        @board[turn][1]=@code_breaker_input
    end
#Checks for whether the bot or the player has guessed the secret code
    def check_for_win_condition
        @matches.all?("black")
    end
#DISPLAYS THE GAME BOARD
    def display_board(turn)
        temp_index = 0
        turn+=1
        turn.times do
            puts "#{@board[temp_index][0]} #{@board[temp_index][1]} #{@board[temp_index][2]}"
            temp_index+=1
        end
    end
#This method plays a single (1) turn of the game if the player is the code breaker
    def player_turn(turn)
        get_player_input()
        compare_guesses()
        update_board(turn)
        system "clear"
        display_board(turn)
    end
    
#this method plays a single (1) turn of the game if the player is the code maker
    def bot_turn(turn)
        get_bot_input()
        compare_guesses()
        update_board(turn)
        display_board(turn)
    end
end

#binding.pry
puts "Do you wish to be the code breaker or the code maker?"
player_role = gets.chomp
game = MASTERMIND.new()
turn = 0
while turn<=12
    puts game.code_row
    if (turn == 12)
        system "clear"
        temp_index = turn-1
        game.display_board(temp_index)
        puts "DEFEAT DEFEAT LEMONS I EAT"
        break
    end
    if player_role == "code breaker"
    game.player_turn(turn)
    turn += 1
    end
    if game.check_for_win_condition == true
        system "clear"
        temp_index = turn-1
        game.display_board(temp_index)
        puts "WINNER WINNER CHICKEN DINNER"
        break
    end
end

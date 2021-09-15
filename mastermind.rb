require 'pry-byebug'

class MASTERMIND
    attr_reader :board, :secret_code_row, :MAIN_COLORS
#creates the game board with some constants
    def initialize(player_role = "code breaker")
        @MAIN_COLORS = ["red","yellow","blue","purple","pink","teal"]
        create_board()
        if player_role == "code maker"
            get_player_input()
            @bot_colors = Array.new(1) {@MAIN_COLORS}.flatten
            @secret_code_row = Array.new(1) {@code_breaker_input}.flatten
            @code_breaker_input = ''
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
        6.times do 
            @board << [temp_column1,temp_column2,"Turn:#{temp_index+=1}"]
        end
        @board
    end
#selects 4 random colors to stand for the code
    def secret_code
        @secret_code_row = []
        4.times do
            ai_colors = Array.new(1) {@MAIN_COLORS}.flatten
            temp_color = ai_colors.sample
            ai_colors.delete(temp_color)
            @secret_code_row << temp_color
        end
    end
#! DOES NOT WORK YET!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    def get_bot_input(turn)

        store_bot_input(temp_input)
    end

        def bot_guess_options(turn)
        temp_color = Array.new(1) {@MAIN_COLORS}
        temp_index = turn - 1
        previous_turn_results = previous_guess_results(turn)
        previous_turn_guesses = @board[turn-1][1]
        if turn == 1
            temp_input = ["red","red","yellow","yellow"]
        end
    end
    def previous_turn_results(turn)
        temp_index = turn - 1
        previous_results =[@board[temp_index][0].count("black"),@board[temp_index][0].count("white")]
        #previous reuslts, previous guesses
    end
#Stores the bot input
    def store_bot_input(temp_input)
        @code_breaker_input = temp_input
    end
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#this calls the request_player_input to take the player input, then validates it and stores it
    def get_player_input

        @available_colors = Array.new(1) {@MAIN_COLORS}.flatten
            temp_input = request_player_input()
            temp_input = validate_player_input(temp_input)
            store_player_input(temp_input)
    end
#requests player for input
    def request_player_input(message = "Choose from one of the following colors")
        puts "#{message}"
        p @available_colors
        temp_input = gets.chomp
        temp_input.split 
    end
#validates the player input, if input is invalid prompts the user to input again
    def validate_player_input(temp_input,comparison_array = @available_colors)
        validation_results = []
        temp_input.each do |input|
            validation_results << comparison_array.include?(input)
        end
        if (validation_results.all?(true) and validation_results.length == 4) == false
            temp_input = request_player_input("Please choose FOUR of the AVAILABLE colors >:(")
            validate_player_input(temp_input, comparison_array)
        else
            temp_input
        end
    end
#stores player input
    def store_player_input(temp_input)
        @code_breaker_input = Array.new(1) {temp_input}.flatten
        #@available_colors.delete(temp_input)
    end
#Checks the player input and compares it with the secret code,
    def correct_colors(temp_row)
        @code_breaker_input.each do |item|
            if temp_row.include?(item)
                @matches.shift
                @matches << "white"
                temp_row[temp_row.index(item)] = "O"
            end
        end
    end
#checks for whether any of the colors in player_input match the colors and positions
#in the secret code
    def correct_positions
        @matches = Array.new(4){"O"}
        temp_row = Array.new(1){@secret_code_row}.flatten
        temp_row.each_with_index do |item,index|
            if temp_row[index] == @code_breaker_input[index]
                temp_row[index] = "O"
                @matches.shift
                @matches << "black"
            end
        end
        puts "#{temp_row}"
        temp_row
    end
#compares the players input with the secret code
    def compare_guesses
        temp_row = correct_positions()
        correct_colors(temp_row)
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
        get_bot_input(turn)
        compare_guesses()
        update_board(turn)
        display_board(turn)
    end
end

#binding.pry
puts "Do you wish to be the code breaker or the code maker?"
player_role = gets.chomp
game = MASTERMIND.new(player_role)
turn = 0
while turn<=6
    puts game.secret_code_row
    if player_role == "code breaker"

        game.player_turn(turn)
        turn += 1
    elsif player_role == "code maker"
        game.bot_turn(turn)
        turn+=1
    end
    if game.check_for_win_condition == true
        system "clear"
        temp_index = turn-1
        game.display_board(temp_index)
        puts "WINNER WINNER CHICKEN DINNER"
        break
    end
    if (turn == 6)
        system "clear"
        temp_index = turn-1
        game.display_board(temp_index)
        puts "DEFEAT DEFEAT LEMONS I EAT"
        break
    end
end

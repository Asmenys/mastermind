require 'pry-byebug'

class MASTERMIND
    attr_reader :board, :secret_code_row, :MAIN_COLORS
#creates the game board with some constants
    def initialize(player_role = "code breaker")
        @MAIN_CHOICES = [1,2,3,4,5,6]
        create_board()
        if player_role == "code maker"
            @ALL_POSSIBLE_CHOICES = @MAIN_CHOICES.repeated_permutation(4).to_a
            get_player_input()
            @bot_colors = Array.new(1) {@MAIN_CHOICES}.flatten
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
            ai_colors = Array.new(1) {@MAIN_CHOICES}.flatten
            temp_color = ai_colors.sample
            ai_colors.delete(temp_color)
            @secret_code_row << temp_color
        end
    end
#! DOES NOT WORK YET!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    def get_bot_input(turn)
        if turn == 0
           temp_input = [1,1,2,2] 
        end
        if turn == 1
            reduce_possible_choices_first_turn()
        end






    end
#*CREATE AN ARRAY OF POSSIBLE COLORS AND POSSIBLE CHOICES
#* FOR FIRST TURN PICK TWO RANDOM COLORS
#* CALCULATE THE RESULT SUM
#* IF THE RESULT SUM IS GREATER THAN 3
#* FILTER THE POSSIBLE CHOICES FOR OPTIONS THAT ONLY INCLUDE BOTH OF THESE COLORS
        binding.pry
        store_bot_input(temp_input)
    end
    def reduce_possible_choices_first_turn(previous_result_sum,previous_guesses)
        if previous_result_sum > 3
            previous_guesses.each do |item|
            @ALL_POSSIBLE_CHOICES = @ALL_POSSIBLE_CHOICES - @ALL_POSSIBLE_CHOICES.filter {|guess| guess.include?(item)}
            end
        end
        if previous_result_sum == 0
            previous_guesses.uniq!
            @MAIN_CHOICES.delete(previous_guesses[0])
            @MAIN_CHOICES.delete(previous_guesses[1])
            @MAIN_CHOICES.each do |choice|
                @ALL_POSSIBLE_CHOICES = @ALL_POSSIBLE_CHOICES.filter{|guess| guess.include?(choice)}
            end
        end
    end
    # def reduce_possible_choices(previous_result_sum,turn)
        
    # end

    def get_previous_results(turn)
        temp_turn = turn - 1
        previous_results = [@board[temp_turn][0].count("black"),@board[temp_turn][0].count("white")]
    end
#!DOES NOT WORK
#Stores the bot input
    def store_bot_input(temp_input)
        @code_breaker_input = temp_input
    end
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#this calls the request_player_input to take the player input, then validates it and stores it
    def get_player_input
            temp_input = request_player_input()
            temp_input = validate_player_input(temp_input)
            store_player_input(temp_input)
    end
#requests player for input
    def request_player_input(message = "Please enter an array of numbers 1-6 each separated by \" \"")
        puts "#{message}"
        temp_input = gets.chomp
        temp_input = temp_input.split
        temp_input = temp_input.map {|item| item.to_i}
    end
#validates the player input, if input is invalid prompts the user to input again
    def validate_player_input(temp_input,comparison_array = @MAIN_CHOICES)
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
    def correct_colors(temp_array)
        temp_player_input = temp_array[1]
        temp_secret_code = temp_array[0]
        temp_player_input.each do |item|
            if temp_secret_code.include?(item)
                @matches.shift
                @matches << "white"
                temp_secret_code[temp_secret_code.index(item)] = "O"
            end
        end
    end
#checks for whether any of the colors in player_input match the colors and positions
#in the secret code
    def correct_positions
        @matches = Array.new(4){"O"}
        temp_player_input = Array.new(1){@code_breaker_input}.flatten
        temp_secret_code = Array.new(1){@secret_code_row}.flatten
        temp_secret_code.each_with_index do |item,index|
            if temp_secret_code[index] == temp_player_input[index]
                temp_player_input[index] = "X"
                temp_secret_code[index] = "O"
                @matches.shift
                @matches << "black"
                #binding.pry
            end
        end
        temp_array = [temp_secret_code, temp_player_input]
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

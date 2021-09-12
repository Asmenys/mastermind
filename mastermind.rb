require 'pry-byebug'
class MASTERMIND
    attr_reader :board, :code_row, :main_colors
    def initialize
        @main_colors = ["red","yellow","blue","purple","pink","teal"]
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
        ai_colors = Array.new(1) {@main_colors}.flatten
        @code_row = []
        4.times do
            temp_color = ai_colors.sample
            ai_colors.delete(temp_color)
            @code_row << temp_color
        end
    end
    def validate_player_input
        @player_input = []
        @available_colors = Array.new(1) {@main_colors}
            4.times do
            temp_input = request_player_input()
            unless available_colors.index(temp_input).class == Integer
                request_player_input()
            else
                store_player_input(temp_input)
            end
        end
    end
    def store_player_input(temp_input)
        @player_input << available_colors[available_colors.index(temp_input)]
        @available_colors.delete(temp_input)
    end
    def request_player_input
        puts "Choose from one of the following colors"
        p @available_colors
        temp_input = gets.chomp
    end
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
    def correct_positions
        @code_row.each_with_index do |item,index|
            if @code_row[index] == @player_input[index]
                @matches.shift
                @matches<< "black"
            end
        end
    end
    def compare_guesses
        correct_colors()
        correct_positions()
        @matches
    end
    def update_board(turn)
        @board[0][0]=@matches
        @board[0][1]=@player_input
    end
    def check_for_win_condition
        @matches.all?("black")
    end
    # def game(turn)
    #     get_player_input()
    #     unless check_for_win_condition() == true
    #         @board[turn][0] = @matches
    #     end
    # end
end

game = MASTERMIND.new()
binding.pry
# turns = 1
# while turns<=12
# game.game(turns)
# end


p "Something"
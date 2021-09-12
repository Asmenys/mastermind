require 'pry-byebug'
#a row of 4 holes
#twelve rows of 4 holes next to a set of 4 holes
#6 different colors
#2 different pegs black and white placed in small holes


#A PATTERN OF 4 RANDOM COLORS IS CHOSEN

class GAME
    attr_reader :board, :code_row, :main_colors
    def initialize
        @main_colors = ["red","yellow","blue","purple","pink","teal"]
        @secondary_colors = ["black","white"]
        code_maker_ai()
    end
private
#creates two 1 by 4 rows
    def rows
        row_uno = Array.new(4)
        row_dos = Array.new(4)
    end
#takes the rows() and makes a game board
    def board
        @board = Array.new(12) { Array.new(2) { rows() } }
    end
#selects 4 random colors to stand for the code
def code_maker_ai
    ai_colors = []
     ai_colors += @main_colors
    @code_row = []
    4.times do
        temp_color = ai_colors.sample
        ai_colors.delete(temp_color)
        @code_row << temp_color
    end
end

public

    def compare_guess(player_input)
        matches = []
        temp_row = [] 
        temp_row += @code_row
        player_input.each do |item|
            if temp_row.include?(item)
                matches << @secondary_colors[1]
                temp_row.delete_at(temp_row.index(item))
            end
        end
        matches
        @code_row.each_with_index do |item,index|
            if @code_row[index] == player_input[index]
                matches.shift
                matches<<@secondary_colors[0]
            end
        end
        matches
    end


end
game_board = GAME.new()
binding.pry

p "Something"
# frozen_string_literal: true

require 'pry-byebug'

class MASTERMIND
  def initialize(player_role)
    @MAIN_CHOICES = [1, 2, 3, 4, 5, 6]
    @POSSIBLE_OPTIONS = Array.new(1) { @MAIN_CHOICES }.flatten
    @TRUE_OPTIONS = []
    create_board
    if player_role == 'code maker'
      @ALL_POSSIBLE_CHOICES = @MAIN_CHOICES.repeated_permutation(4).to_a
      get_player_input
      @bot_colors = Array.new(1) { @MAIN_CHOICES }.flatten
      @secret_code_row = Array.new(1) { @code_breaker_input }.flatten
      @code_breaker_input = ''
    else
      secret_code
    end
  end

  # creates the game board
  def create_board
    temp_index = 0
    temp_column1 = Array.new(4) { 'O' }
    temp_column2 = Array.new(4) { 'O' }
    @board = []
    10.times do
      @board << [temp_column1, temp_column2, "Turn:#{temp_index += 1}"]
    end
    @board
  end

  # selects 4 random colors to stand for the code
  def secret_code
    @secret_code_row = []
    4.times do
      ai_colors = Array.new(1) { @MAIN_CHOICES }.flatten
      temp_color = ai_colors.sample
      ai_colors.delete(temp_color)
      @secret_code_row << temp_color
    end
  end

  def get_bot_input(turn)
    current_result_sum = get_current_results(turn)
    current_result_sum = current_result_sum[0] + current_result_sum[1]
    previous_result_sum = get_current_results(turn - 1)
    previous_result_sum = previous_result_sum[0] + previous_result_sum[1]
    temp_turn = turn + 1
    case turn
    when 0
      temp_input = Array.new(4) { temp_turn }
      @ALL_POSSIBLE_CHOICES.delete(temp_input)
    when 1
      if current_result_sum.zero?
        reduce_possible_choices(turn)
        temp_input = Array.new(4) { temp_turn }
      else
        filter_whites(turn)
        current_result_sum.times do
          @TRUE_OPTIONS << turn
        end
        @ALL_POSSIBLE_CHOICES = @ALL_POSSIBLE_CHOICES.filter do |guess|
          @TRUE_OPTIONS.count(turn) == guess.count(turn)
        end
        temp_input = get_temp_input(turn)
      end
      @ALL_POSSIBLE_CHOICES.delete(temp_input)
    when 2...6
      if current_result_sum.zero?
        reduce_possible_choices(turn)
        temp_input = Array.new(4) { temp_turn }
        @ALL_POSSIBLE_CHOICES.delete(temp_input)
      else
        filter_whites(turn)
        delta_result_sum = current_result_sum - previous_result_sum
        temp_input = case_temp_input(turn, delta_result_sum)
      end
    when 6...10
      # binding.pry
      filter_whites(turn)
      temp_input = @ALL_POSSIBLE_CHOICES.sample
      @ALL_POSSIBLE_CHOICES.delete(temp_input)
    end
    store_bot_input(temp_input)
  end

  def case_temp_input(turn, delta_result_sum)
    delta_result_sum.times do
      @TRUE_OPTIONS << turn
    end
    @ALL_POSSIBLE_CHOICES = @ALL_POSSIBLE_CHOICES.filter { |guess| @TRUE_OPTIONS.count(turn) == guess.count(turn) }
    temp_input = get_temp_input(turn)
    @ALL_POSSIBLE_CHOICES.delete(temp_input)
    temp_input
  end

  def filter_whites(turn)
    previous_input = @board[turn - 1][1]
    current_results = get_current_results(turn)
    if (current_results[0]).zero?
      previous_input.each_with_index do |item, index|
        @ALL_POSSIBLE_CHOICES -= @ALL_POSSIBLE_CHOICES.filter do |choice|
          choice[index] == item
        end
      end
    end
  end

  def get_temp_input(turn)
    # binding.pry
    temp_input = []
    temp_input << @TRUE_OPTIONS
    temp_input = temp_input.flatten
    temp_index = 4 - temp_input.length
    temp_index.times do
      temp_input << turn + 1
    end
    temp_input
  end

  def reduce_possible_choices(turn)
    current_result_sum = get_current_results(turn)
    current_result_sum = current_result_sum[0] + current_result_sum[1]
    result_changes = compare_result_changes(turn)
    current_guesses = Array.new(1) { @board[turn - 1][1] }.flatten
    previous_guesses = Array.new(1) { @board[turn - 2][1] }.flatten

    if current_result_sum.zero?
      current_guesses.uniq!
      current_guesses.each do |choice|
        @POSSIBLE_OPTIONS.delete(choice)
        @ALL_POSSIBLE_CHOICES -= @ALL_POSSIBLE_CHOICES.filter do |guess|
          guess.include?(choice)
        end
      end
    end
  end

  def compare_result_changes(turn)
    current_results = get_current_results(turn)
    previous_results = get_current_results(turn - 1)
    result_changes = (current_results - previous_results)
    # binding.pry
  end

  def get_current_results(turn)
    temp_turn = turn - 1
    current_results = [@board[temp_turn][0].count('black'), @board[temp_turn][0].count('white')]
  end

  # Stores the bot input
  def store_bot_input(temp_input)
    @code_breaker_input = temp_input
  end

  # this calls the request_player_input to take the player input, then validates it and stores it
  def get_player_input
    temp_input = request_player_input
    temp_input = validate_player_input(temp_input)
    store_player_input(temp_input)
  end

  # requests player for input
  def request_player_input(message = 'Please enter an array of numbers 1-6 each separated by " "')
    puts message.to_s
    temp_input = gets.chomp
    temp_input = temp_input.split
    temp_input = temp_input.map(&:to_i)
  end

  # validates the player input, if input is invalid prompts the user to input again
  def validate_player_input(temp_input, comparison_array = @MAIN_CHOICES)
    validation_results = []
    temp_input.each do |input|
      validation_results << comparison_array.include?(input)
    end
    if (validation_results.all?(true) && (validation_results.length == 4)) == false
      temp_input = request_player_input('Please choose FOUR of the AVAILABLE colors >:(')
      validate_player_input(temp_input, comparison_array)
    else
      temp_input
    end
  end

  # stores player input
  def store_player_input(temp_input)
    @code_breaker_input = Array.new(1) { temp_input }.flatten
    # @available_colors.delete(temp_input)
  end

  # Checks the player input and compares it with the secret code,
  def correct_colors(temp_array)
    temp_player_input = temp_array[1]
    temp_secret_code = temp_array[0]
    temp_player_input.each do |item|
      next unless temp_secret_code.include?(item)

      @matches.shift
      @matches << 'white'
      temp_secret_code[temp_secret_code.index(item)] = 'O'
    end
  end

  # checks for whether any of the colors in player_input match the colors and positions
  # in the secret code
  def correct_positions
    @matches = Array.new(4) { 'O' }
    temp_player_input = Array.new(1) { @code_breaker_input }.flatten
    temp_secret_code = Array.new(1) { @secret_code_row }.flatten
    temp_secret_code.each_with_index do |_item, index|
      next unless temp_secret_code[index] == temp_player_input[index]

      temp_player_input[index] = 'X'
      temp_secret_code[index] = 'O'
      @matches.shift
      @matches << 'black'
      # binding.pry
    end
    temp_array = [temp_secret_code, temp_player_input]
  end

  # compares the players input with the secret code
  def compare_guesses
    temp_row = correct_positions
    correct_colors(temp_row)
    @matches
  end

  # updates the code with the players input and appropriate results
  def update_board(turn)
    @board[turn][0] = @matches
    @board[turn][1] = @code_breaker_input
  end

  # Checks for whether the bot or the player has guessed the secret code
  def check_for_win_condition(turn)
    # binding.pry
    @board[turn - 1][0].all?('black')
    # binding.pry
  end

  # DISPLAYS THE GAME BOARD
  def display_board(turn)
    #  binding.pry
    temp_index = 0
    turn += 1
    turn.times do
      puts "#{@board[temp_index][0]} #{@board[temp_index][1]} #{@board[temp_index][2]}"
      temp_index += 1
    end
  end

  # This method plays a single (1) turn of the game if the player is the code breaker
  def player_turn(turn)
    get_player_input
    compare_guesses
    update_board(turn)
    system 'clear'
    display_board(turn)
  end

  # this method plays a single (1) turn of the game if the player is the code maker
  def bot_turn(turn)
    get_bot_input(turn)
    compare_guesses
    update_board(turn)
    display_board(turn)
  end
end

class PLAYER_CREATOR
  attr_reader :player_role

  def initialize
    @possible_roles = ['code breaker', 'code maker']
    puts 'Do you wish to be the code breaker or the code maker?'
    player_role = gets.chomp
    player_role = validate_role_choice(player_role)
    @player_role = player_role
  end

  def validate_role_choice(player_role)
    unless @possible_roles.include?(player_role)
      puts 'Please choose a valid role'
      player_role = gets.chomp
      validate_role_choice(player_role)
    end
    player_role
  end
end

player = PLAYER_CREATOR.new
# binding.pry
game = MASTERMIND.new(player.player_role)
turn = 0
while turn <= 10
  case player.player_role
  when 'code breaker'
    # p game.secret_code_row
    game.player_turn(turn)
    turn += 1
  when 'code maker'
    game.bot_turn(turn)
    turn += 1
  end
  if game.check_for_win_condition(turn) == true
    system 'clear'
    temp_index = turn - 1
    game.display_board(temp_index)
    if player.player_role == 'code breaker'
      puts 'YOU WIN'
    else
      puts 'THE CODE BREAKER HAS WON'
    end
    break
  end
  next unless turn == 10

  system 'clear'
  temp_index = turn - 1
  game.display_board(temp_index)
  if player.player_role == 'code breaker'
    puts 'THE CODE MAKER HAS WON'
  else
    puts 'You win!'
  end
  break
end

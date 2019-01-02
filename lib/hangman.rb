class Hangman
  attr_accessor :game_over

  def initialize
    @answer = pick_answer
    @game_over = ""
    @wrong_guesses = 0
    print_rules
  end

  def start_turn
    return if @game_over == "win" || @game_over == "lose"
    draw_hangman
    draw_letters
    print_menu
    choice = "e"
    exit if choice.downcase == "exit"
    save_game if choice == "save"
    if (choice !~ /\W/)
      check_guess(choice.downcase)
    else
      puts "\nInvalid input. Try again: "
    end
  end

  def load_save_data;  end #TODO
  
  private

  def print_rules
    puts "Welcome to Hangman! Each turn you will have the option "\
        "of either guessing a letter of the secret word or "\
        "saving your progress to come back later.\n"
  end

  def check_for_win;  end # TODO

  def print_menu
    puts "\n\nEnter a letter to make a guess, 'save' to save and exit the game, or 'exit' to exit the game: "
  end
=begin
REWORK HASH TO JUST BE LETTER: "_"
=
=
=
=end
  def pick_answer
    word = File.readlines("dictionary.txt").sample(1)[0].gsub(/\W/, '').downcase
    count = 0
    hash = Hash.new { |h, k| h[k] = [] }
    word.each_char do |c|
      hash[count.to_s.to_sym][0] = c
      hash[count.to_s.to_sym][1] = "_"
      count += 1
    end
    hash
  end

  def draw_hangman
    # TODO format string to put in middle of screen
    puts "  _______"
    puts "  |      |"
    puts "  |      #{"O" if @wrong_guesses > 0}"
    puts "  |     #{"\\" if @wrong_guesses > 2}#{"|" if @wrong_guesses > 1}#{"/" if @wrong_guesses > 3}"
    puts "  |     #{"/" if @wrong_guesses > 4} #{"\\" if @wrong_guesses > 5}"
    puts "  |"
    puts " /|\\"
    puts "/ | \\\n\n"
  end

  def draw_letters
    @answer.each do |key, value|
      print "#{value[1]} "
    end
  end

  def check_guess(choice)
    return bad_guess(choice) if @answer.value?(choice) == false
    @answer.each do |k, v|
      v[1] = choice if v[0] == choice
    end
  end
  
  def save_game; end

  def bad_guess(choice)
    puts "There are no #{choice}'s in the word."
    @wrong_guesses += 1
  end

end

def game_loop(game, save = false)
  game.load_save_data if save
  loop do
    break if game.game_over != ""
    game.start_turn
  end
end

game = Hangman.new
game_loop(game) # FIX THIS WHEN SAVES IMPLEMENTED

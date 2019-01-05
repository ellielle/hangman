require "./game_data.rb"

class Hangman
  include GameData

  def initialize(pick = pick_answer, wrongs = 0, score = create_score)
    @answer = pick
    @wrong_guesses = wrongs
    set_score(score)
    @wrong = false
    print_rules
  end

  def start_turn
    unless @wrong
      draw_hangman
      draw_letters
    end
    print_menu
    choice = gets.chomp
    exit if choice.downcase == "exit"
    save_game if choice.downcase == "save"
    if choice =~ /[a-zA-Z]/
      check_guess(choice.downcase)
    else
      puts "\nInvalid input. Try again: "
      @wrong = true
    end
  end

  private
  def create_score
    score = {["win"] => 0, ["lose"] => 0}
  end

  def print_rules
    puts "Welcome to Hangman! Each turn you will have the option "\
        "of either guessing a letter of the secret word or "\
        "saving your progress to come back later.\n"
  end

  def you_win
    puts "You won! Type 'exit' to quit or 'again' to start again."
    choice = gets.chomp
    exit if choice == "exit"
    start_game if choice == "again"
    @score["wins"] += 1
  end

  def print_menu
    puts "\nYou have #{6 - @wrong_guesses} guesses left."
    puts "Enter a letter to make a guess, 'save' to save and exit the game, or 'exit' to exit the game: "
  end

  def pick_answer
    word = File.readlines("../dictionary.txt").sample(1)[0].gsub(/\W/, '').downcase
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
    @answer.each { |k, value| print "#{value[1]} " }
  end

  def check_guess(choice)
    return bad_guess(choice) unless @answer.values.flatten.include?(choice)
    @answer.each { |k, v| v[1] = choice if v[0] == choice }
    @wrong = false
  end

  def bad_guess(choice)
    puts "There are no #{choice}'s in the word."
    @wrong = false
    @wrong_guesses += 1
    you_lose if @wrong_guesses == 6
  end

  def you_lose
    display_score
    puts "You lost. Type 'exit' to quit or 'retry' to start again."
    @score["loses"] += 1
    choice = gets.chomp
    exit if choice == "exit"
    start_game if choice == "retry"
    you_lose
  end
  
  def display_score
    puts "Score: #{@score["wins"]} W/#{@score["loses"]} L"
  end
end

def game_loop(game)
  loop do
    game.start_turn
  end
end

def start_game
  include GameData
  choice = ""

  if File.exist?("../SAVE1")
    puts "Would you like to load a previous save?(y/n) "
    loop do
      choice = gets.chomp
      break if choice == "y" || choice == "n"
    end
    if choice == "y" # TODO split up data
      begin
        data = load_save_data
        data = from_json(data[0])
        answer = data[0]["answer"]
        wrongs = data[0]["wrong_guesses"]
        score = data[0]["score"]
      rescue
        puts "Invalid save file."
      end
    end
  end
  choice == "y" ? game = Hangman.new(answer, wrongs, score) : game = Hangman.new
  game_loop(game) # TODO FIX THIS WHEN SAVES IMPLEMENTED
end
start_game

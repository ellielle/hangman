require "json"

module GameData
  def load_save_data
    data = File.readlines("../SAVE1")
  end

  def set_score(score)
    @score = score
  end

  def from_json(string)
    data = JSON.parse(string)
  end

  private

  def to_json
    JSON.generate [ answer: @answer, wrong_guesses: @wrong_guesses, score: @score ]
  end

  def save_game
    save = to_json
    File.open("../SAVE1", "w") { |file| file.print save }
    puts "Press ENTER to exit."
    gets
    exit
  end
end
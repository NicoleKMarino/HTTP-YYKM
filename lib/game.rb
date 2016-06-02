class Game

  attr_reader :random_number,
              :guess_count,
              :most_recent_guess,
              :most_recent_guess_result,
              :game_active

  def initialize
    @random_number = generate_random_number
    @guess_count = 0
    @most_recent_guess = nil
    @most_recent_guess_result = ""
    @game_active = false
  end

  def generate_random_number
    random_number = rand(1..99)
  end

  def play(guess = gets.chomp.to_i)
    @game_active = true
    @guess_count += 1
    @most_recent_guess = guess
    @most_recent_guess_result = compare_guess(@most_recent_guess, @random_number)
  end

  def compare_guess(guess, answer)
    if guess > answer
      "too high"
    elsif guess < answer
      "too low"
    elsif guess == answer
      "correct"
      end_game("Thanks for playing")
    else
      puts "invalid"
    end
  end

  def end_game(message)
    @game_active = false
    puts message
    exit
  end

end

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

  def play(guess)
    @game_active = true
    @guess_count += 1
    @most_recent_guess = guess
    @most_recent_guess_result = compare_guess(@most_recent_guess, @random_number)
  end

  def compare_guess(guess, answer)
    if guess > answer
      return "too high"
    elsif guess < answer
      return "too low"
    elsif guess == answer
      return "correct, Thanks for playing!"
      end_game("Thanks for playing")
    else
      return "invalid"
    end
  end

  def end_game(message)
    @game_active = false
    puts message
    exit
  end

  def find_guess(client, request_lines)
   length = request_lines[3].partition(' ').last.to_i
   body = client.read(length)
   number_broken = body.gsub(/[^0-9a-z ]/i,'').partition('game').last
   guess = number_broken.scan(/\d+/)[0]
   play(guess.to_i)
  end

end

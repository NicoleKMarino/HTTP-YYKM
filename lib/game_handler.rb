module GameHandler

  def game_response_paths(request, client)
    if request[0] == "POST" && request[1].include?("start")
      return "Good luck!"
    elsif request[0] == "GET"
      return "#{@gameplay.guess_count} guesses have been taken " +
             "\nThe last guess was #{@gameplay.most_recent_guess}, #{@gameplay.most_recent_guess_result}"
    elsif request[0] == "POST"
      @gameplay.find_guess(client, @request_lines)
      return @gameplay.most_recent_guess_result
    end
  end

end

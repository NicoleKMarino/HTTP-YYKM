module GameHandler

  def game_response_paths(request, client)
    if request[0] == "POST" && request[1].include?("start")
      if @gameplay.game_active == true
        @status = "403 Forbidden"
        return "403 Forbidden: game already in progress"
      else
        @status = "301 Moved Permanently"
        @gameplay = Game.new
        return "Redirecting to start a new game, Good luck!"
      end
    elsif request[0] == "GET"
      return "#{@gameplay.guess_count} guesses have been taken " +
             "\nThe last guess was #{@gameplay.most_recent_guess}, #{@gameplay.most_recent_guess_result}"
    elsif request[0] == "POST"
      @gameplay.find_guess(client, @request_lines)
      return @gameplay.most_recent_guess_result
    end
  end

end

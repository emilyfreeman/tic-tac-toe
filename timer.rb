class Timer
  def game_time(start_time)
    time_score = ((Time.now - start_time).to_i)
    minutes = time_score / 60
    seconds = time_score % 60
    "#{minutes} #{minutes_syntax(minutes)} and #{seconds} #{seconds_syntax(seconds)}"
  end

  def guess_syntax
    guess_count == 1 ? "guess" : "guesses"
  end

  def minutes_syntax(minutes)
    minutes == 1 ? "minute" : "minutes"
  end

  def seconds_syntax(seconds)
    seconds == 1 ? "second" : "seconds"
  end
end

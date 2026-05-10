module JiraCommentRenderer
  module_function

  # Renders a Jira wiki-markup comment containing the player votes and the
  # high/low summary for an estimate that was just accepted.
  def render(game)
    voters = game.games_players.voters
    [
      "h4. Agile Poker — vote summary",
      "",
      players_table(voters),
      "",
      "h4. Summary",
      "",
      summary_table(voters)
    ].join("\n")
  end

  def players_table(voters)
    lines = []
    lines << "||Player||Complexity||Amount of Work||Unknowns/Risks||Total||Fibonacci||"
    voters.each do |player|
      lines << "|#{escape(player.name)}|#{value(player.complexity)}|#{value(player.amount_of_work)}|#{value(player.unknown_risk)}|#{value(player.total_points)}|#{value(player.fibonacci_vote)}|"
    end

    count = voters.players_voted.count
    if count.positive?
      lines << "|Average|" \
        "#{average(voters.sum(:complexity), count)}|" \
        "#{average(voters.sum(:amount_of_work), count)}|" \
        "#{average(voters.sum(:unknown_risk), count)}|" \
        "#{average(voters.sum_total_points, count)}|" \
        "#{average(voters.sum_fibonacci_vote, count)}|"
    end

    lines.join("\n")
  end

  def summary_table(voters)
    return "_No votes recorded._" if voters.players_voted.empty?

    highest = voters.highest_voter
    lowest  = voters.lowest_voter
    lines = []
    lines << "||Metric||Player||Total||Fibonacci||"
    lines << "|Highest|#{escape(highest.name)}|#{number(highest.total_points)}|#{number(highest.fibonacci_vote)}|"
    lines << "|Lowest|#{escape(lowest.name)}|#{number(lowest.total_points)}|#{number(lowest.fibonacci_vote)}|"
    lines.join("\n")
  end

  def average(sum, count)
    return 0 if sum.nil? || sum.zero? || count.zero?
    avg = sum.to_d / count.to_d
    rounded = avg.round(2)
    rounded == rounded.to_i ? rounded.to_i : rounded.to_f
  end

  def number(value)
    return "—" if value.nil?
    value == value.to_i ? value.to_i : value
  end

  def value(v)
    v.nil? ? "—" : v
  end

  def escape(text)
    text.to_s.gsub("|", "\\|")
  end
end

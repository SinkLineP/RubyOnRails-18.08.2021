module InputValidator
  def choose_game_type
    puts "Choose the game type:"
    puts "'cc' for computer vs computer"
    puts "'hh' for human vs human"
    puts "'hc' for human vs computer"
    puts
    game_type = gets.chomp
    puts

    while wrong_game_type(game_type)
      puts "\nYou entered '#{game_type}'. Choose these game type::\n"
      puts "'cc' for computer vs computer"
      puts "'hh' for human vs human"
      puts "'hc' for computer vs human"
      puts
      game_type = gets.chomp
      puts
    end

    parse_game_type(game_type)
  end

  def choose_game_level
    puts "Choose the game level:"
    puts "'0' for easy"
    puts "'1' for medium"
    puts "'2' for hard"
    game_level = gets.chomp
    puts

    while wrong_game_level(game_level)
      puts "\nYou entered '#{game_level}'. Choose these game level::\n"
      puts "'0' for easy"
      puts "'1' for medium"
      puts "'2' for hard"
      game_level = gets.chomp
      puts
    end

    parse_game_level(game_level)
  end

  private

  def wrong_game_type(game_type)
    game_type != 'cc' &&
    game_type != 'hh' &&
    game_type != 'hc'
  end

  def wrong_game_level(game_level)
    game_level != '0' &&
    game_level != '1' &&
    game_level != '2'
  end

  def parse_game_type(type)
    {
      'cc' => :computer_vs_computer,
      'hh' => :human_vs_human,
      'hc' => :human_vs_computer
    }[type]
  end

  def parse_game_level(level)
    {
      '0' => :easy,
      '1' => :medium,
      '2' => :hard
    }[level]
  end
end

# frozen_string_literal: true

require 'yaml'

def save_game
end

def load_game
end

def player_input(game_obj)
  puts "Guess a letter!\n"
  begin
    guess = gets.chomp
    unless guess.match?(/[[:alpha:]]|1|2|3/)
      raise "Not a valid input!\n"
    end
    @guessed_letters.each do |letter|
      if guess == letter
        raise "You already guessed that!\n"
      end
    end
    game_obj.check_guess(guess)
  rescue
    retry
  end
end

# load word list and cull words we don't wish to use
def load_words
  word_list = []
  begin
    source = File.read('google-10000-english-no-swears.txt')
    source.split("\n") do |word|
      if word.length > 5 && word.length < 12
        word_list.insert(-1, word)
      end
    end
  rescue
    puts 'Error: Could not find word resource!'
  end
  return word_list
end

class GameState
  attr_accessor :curr_state, :guessed_letters, :num_guesses
  attr_writer :curr_word

  def initialize(word_list)
    @curr_word = word_list[rand(word_list.length)]
    @curr_state = []
    @curr_state.fill('_', 0, @curr_word.length)
    puts "Welcome to a new game of Hangman!\nType 1 at any time to save the game!\n
      Type 2 at any time to load a save!\n"
  end

  def win?
    return true if @curr_word == @curr_state.join
  end

  def check_guess(guess)
    i = 0
    @curr_word.each_char do |letter|
      if guess == letter { @curr_state[i] = guess }
        i += 1
      end
    end
  end
end

# initialize word list
word_list = load_words

# game loop
loop do
  game = GameState.new(word_list)
  player_input(game)
end

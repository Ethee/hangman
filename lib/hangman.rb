# frozen_string_literal: true

require 'yaml'

def save_game(game_obj)
  Dir.mkdir('saves') unless Dir.exist?('saves')
  save_name = Time.new.strftime('%F_%H%M%S')
  File.open("saves/#{save_name}", 'w') { |file| file.write(game_obj.to_yaml) }
end

def load_game
end

def player_input(game_obj)
  puts "Guess a letter!\n"
  begin
    guess = gets.chomp
    unless guess.match?(/[[:alpha:]]|1|2|3/) && guess.length == 1
      puts "Not a valid input!\n"
      raise
    end
    case guess
    when '1'
      save_game(game_obj)
    when '2'
      load_game
    when '3'
      exit
    else
      game_obj.guessed_letters.each do |letter|
        if guess == letter
          puts "You already guessed that!\n"
          raise
        end
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
    @num_guesses = 0
    @curr_word = word_list[rand(word_list.length)]
    @guessed_letters = ['_']
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
      if letter == guess
        @curr_state[i] = guess
      end
      i += 1
    end
    @num_guesses += 1
    puts @curr_state.join(' '), "\nNum of failed attempts: #{@num_guesses} (max 7)"
    @guessed_letters.insert(-1, guess)
  end
end

# initialize word list and game object
word_list = load_words
game = GameState.new(word_list)

# game loop
loop do
  player_input(game)
end

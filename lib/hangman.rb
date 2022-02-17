# frozen_string_literal: true

# load list of words and cull words we don't wish to use
def initialize
  source_words = File.read('google-10000-english-no-swears.txt')
  @word_list = source_words.split("\n")
  @word_list.delete_if { |word| word.to_s.length < 5 }
  @word_list.delete_if { |word| word.to_s.length < 12 }
end

def pick_word
  @word_list[rand(@word_list.length)]
end

def new_game
end

def save_game
end

def make_guess
end

require 'json'
require 'open-uri'

# Games controller
class GamesController < ApplicationController
  def home
    # render'/'
  end

  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample }
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters].split(" ")
    if valid_from_grid?(@letters, @answer) && english_word?(@answer)
      @result = "Congratulations! #{@answer.upcase} is a valid English word!"
    elsif valid_from_grid?(@letters, @answer)
      @result = "Sorry but the #{@answer.upcase} doesn't seem to be a valid English word..."
    else
      @result = "Sorry but the #{@answer.upcase} can't be build from #{@letters.join(', ')}"
    end
  end

  private

  def valid_from_grid?(letters, answer)
    combination = letters.clone.sort
    proposals = answer.downcase.split('')
    proposals.each do |letter|
      return false unless combination.include?(letter)

      combination.delete(letter)
    end
    true
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    le_wagon_feedback = URI.open(url).read
    feedback = JSON.parse(le_wagon_feedback)
    feedback["found"]
  end
end

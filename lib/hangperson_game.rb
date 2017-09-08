class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses
  attr_accessor :check_win_or_lose
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = word.gsub(/[a-zA-Z]/, "-")
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def guess(character)
    raise ArgumentError.new unless !character.nil? and  character != '' and character =~ /^[a-zA-Z]+$/
    if @word =~ /#{character}/i
      if @guesses !~ /#{character}/i
        @guesses += character
        (0 ... @word.length).find_all { |i| @word[i,1] == character }.each do |i|
          @word_with_guesses[i] = character
        end
        @check_win_or_lose = ( @word_with_guesses.include?("-") ? :play : :win)
        return true
      end
    else
      if @wrong_guesses !~ /#{character}/i
        @wrong_guesses += character
        @check_win_or_lose = ( @wrong_guesses.length.eql?(7) ? :lose : :play)
        return true
      end
    end
    return false
  end

end

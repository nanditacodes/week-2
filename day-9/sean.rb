require 'io/console'
require 'colorize'

class Card
  attr_accessor :name, :value

  def initialize name, value
    @name = name
    @value = value
  end

  def value
    if @name == "J" || @name == "Q" || @name == "K"
      value = 10
    elsif @name == "A"
      value = 11
    else
      value = @name
    end
  end
end

class Deck

  def initialize
    @cards = []
  end

  def deck
    name = [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]
    suit = ["♤","♧","♡","♢"]
    # See why - name first and suit next so you can get an array element like
    # 3♡ instead of ♡3.
    new_deck = name.product(suit).shuffle
    # See  why - card is a regular array - does not have a name and a suit . It is not an
    #instance of a class. So - use first and last to extract stuff.
    new_deck.each {|card| @cards << Card.new(card.first,card.last)}
  end

  def hit(who)
    card = @cards.shift
    who.hand << card
  end
end

class Player
  attr_accessor :who, :hand, :value

  def initialize who
    @hand = []
    @who = who
    @score = 0
  end

  def score
    score = 0
    hand.each do |card|
      score += card.value
    end
    return score
  end

  def show_hand
    puts "#{self.who} hand is: "
    @hand.each do |card|
      puts card
    end
  end

  def busted_or_21?
    if self.score > 21
      puts "Busted! #{self.who} Wins!"
    else self.score == 21
      # tie?
      puts "Blackjack! #{self.who} Wins!"
    end
  end
end

class Game

  attr_accessor :dealer, :player, :cards

  def initialize cards, dealer, player
    @messages = []
    @cards = cards
    @dealer = dealer
    @player = player
  end

  def run_game
    # dealer.hand = []
    # player.hand = []
    deal
    dealer_score = dealer.score
    player_score = player.score
    player.busted_or_21?
    dealer.busted_or_21?
  end
      # system "clear" or system "cls"
      # title
      # print_messages
      # deal
      # dealer.show_hand
      # player.show_hand
      # # blackjack?
      # print_messages
      # # players_turn
      # # dealers_turn
      # # check_score
      # move = STDIN.getch
      # apply_move(move)
      # print_messages
    # end

  def title
    puts "-----------------------"
    title = "Blackjack".colorize(color: :blue)
    puts "-------" + title.blink + "-------"
    puts "-----------------------"
    puts " Press C for Controls"
    puts "***********************".colorize(color: :green)
  end

  def controls
    puts "During game press and of the following:"
    puts "Press H to HIT or S to STAY."
    puts "Press R to view Rules."
    puts "Press Q to Quit."
    puts "From here press N to New Game!"
    move = STDIN.getch
    controls_move(move)
  end

  def print_messages
    @messages.each do |message|
      puts "#{message}"
    end
    @messages = []
  end

  def controls_move move

    case move.downcase
    when 'r' then rules
    when 'n' then run_game
    when 'q' then exit
    else
      puts "Sorry, that is not an option. New Game or Quit?"
    end
  end

  def apply_move move

    case move.downcase
    when 'h' then hit
    when 's' then stay
    when 'r' then rules
    when 'c' then controls
    when 'n' then run_game
    when 'q' then exit
    else
      @messages << "Sorry, that is not an option."
    end
  end

  def rules
    system "clear" or system "cls"
    puts "*****************************"
    puts "------------RULES------------"
    puts "Each card holds a value between 2 and 11. Kings, Queens and Jacks are each worth"
    puts "10. An Ace is worth 11. The goal of the game is to get 21 or as close to 21 without"
    puts "going over."
    puts "Both the player and the dealer are dealt 2 cards. You must decide whether to HIT or"
    puts "STAY. Choosing HIT will add another card to you hand. Choosing STAY will keep you"
    puts "at your present total ending your turn. At which point it is the dealer's turn. Once"
    puts "the dealer's turn is over a winner will be decided based on who has the highest value"
    puts "hand. If at any point the dealer or the player hand goes over 21 the other wins."
    puts "First one to 21 wins! Good Luck!"
    move = STDIN.getch
    controls_move(move)
  end

  # def game_over?
  #   score_21 = blackjack?
  #   over_21 = busted?
  #   return score_21 || over_21
  # end

  def blackjack?
    no_21 = true
    if @player_score == 21
      @messages << "21! You Win!!!!"
      no_21 = false
    else @dealer_score == 21
      @messages << "21! Dealer Wins!!!!"
      no_21 = false
    end
    return no_21
  end

  def check_score
    case
    when @player_score = @dealer_score then @messages << "Tie Game!"
    when @player_score > @dealer_score then @messages << "You Win!!!!"
    when @player_score < @dealer_score then @messages << "Dealer Wins!"
    end
  end

  # def check_for_21
  #   case score
  #   when player_score = dealer_score then tie
  #   when player_score = 21 then win
  #   when dealer_score = 21 then lose
  #   when player_score > 21 then lose
  #   when dealer_score > 21 then win
  #   end
  # end

  def hands
    dealer.hand = []
    player.hand = []
  end

  def deal
    2.times do
      self.cards.hit(dealer)
      self.cards.hit(player)
    end
  end

  def dealer_turn
    until dealer.score > 16 do
      self.cards.hit(dealer)
      dealer.score
      busted_or_21?
      #tie?
    end
    dealer.show_hand
  end

  def players_turn
    puts "Hit of Stay?!"
    move = STDIN.getch
    apply_move move
    until move == "s" do
      self.cards.hit(player)
      player.show_hand
      player.score
      busted_or_21?
      move = STDIN.getch
      apply_move move
    end
  end
end

player = Player.new("Player")
dealer = Player.new("Dealer")
cards = Deck.new
# See why - cards was not printing because you were not calling deck() on it.
cards.deck
game = Game.new(cards, dealer, player)
game.run_game
